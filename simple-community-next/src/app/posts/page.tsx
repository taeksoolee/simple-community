import Link from "next/link";
import { getSession } from "@/lib/auth";
import { prisma } from "@/lib/db";

const PER_PAGE = 10;

export default async function PostsPage({
  searchParams,
}: {
  searchParams: Promise<{ page?: string }>;
}) {
  const { page } = await searchParams;
  const currentPage = Math.max(1, parseInt(page ?? "1", 10));
  const skip = (currentPage - 1) * PER_PAGE;

  const [posts, total] = await Promise.all([
    prisma.post.findMany({
      include: { user: true },
      orderBy: { createdAt: "desc" },
      take: PER_PAGE,
      skip,
    }),
    prisma.post.count(),
  ]);

  const totalPages = Math.ceil(total / PER_PAGE);
  const user = await getSession();

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-gray-100">게시글 목록</h1>
        {user && (
          <Link
            href="/posts/new"
            className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700"
          >
            새 글 작성
          </Link>
        )}
      </div>

      <div className="bg-white dark:bg-gray-800 shadow overflow-hidden sm:rounded-md border border-gray-200 dark:border-gray-700">
        {posts.length > 0 ? (
          <>
            <ul className="divide-y divide-gray-200 dark:divide-gray-700">
              {posts.map((post) => (
                <li key={post.id}>
                  <Link
                    href={`/posts/${post.id}`}
                    className="block hover:bg-gray-50 dark:hover:bg-gray-700 px-4 py-4 sm:px-6"
                  >
                    <div className="flex items-center justify-between">
                      <p className="text-lg font-medium text-indigo-600 dark:text-indigo-400 truncate">
                        {post.title}
                      </p>
                      <p className="ml-2 px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                        {new Date(post.createdAt).toLocaleString("ko-KR")}
                      </p>
                    </div>
                    <p className="mt-2 text-sm text-gray-500 dark:text-gray-400">
                      작성자: {post.user.emailAddress}
                    </p>
                  </Link>
                </li>
              ))}
            </ul>
            {totalPages > 1 && (
              <div className="px-4 py-3 border-t border-gray-200 flex justify-center gap-2">
                {currentPage > 1 && (
                  <Link
                    href={`/posts?page=${currentPage - 1}`}
                    className="px-3 py-2 text-sm font-medium text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md hover:bg-gray-50 dark:hover:bg-gray-600"
                  >
                    ← 이전
                  </Link>
                )}
                {Array.from({ length: totalPages }, (_, i) => i + 1).map((p) => (
                  <Link
                    key={p}
                    href={`/posts?page=${p}`}
              className={`px-3 py-2 text-sm font-medium rounded-md ${
                p === currentPage
                  ? "text-white bg-indigo-600"
                  : "text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600"
              }`}
                  >
                    {p}
                  </Link>
                ))}
                {currentPage < totalPages && (
                  <Link
                    href={`/posts?page=${currentPage + 1}`}
                    className="px-3 py-2 text-sm font-medium text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md hover:bg-gray-50 dark:hover:bg-gray-600"
                  >
                    다음 →
                  </Link>
                )}
              </div>
            )}
          </>
        ) : (
          <div className="text-center py-12">
            <p className="text-gray-500 dark:text-gray-400">아직 게시글이 없습니다</p>
            {user && (
              <p className="mt-2">
                <Link href="/posts/new" className="text-indigo-600 dark:text-indigo-400 hover:text-indigo-500 dark:hover:text-indigo-300">
                  첫 게시글 작성하기
                </Link>
              </p>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
