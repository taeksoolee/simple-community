import { notFound } from "next/navigation";
import Link from "next/link";
import { getSession } from "@/lib/auth";
import { prisma } from "@/lib/db";
import { ChatBubbleLeftIcon, PencilSquareIcon, LockClosedIcon } from "@heroicons/react/24/outline";
import { DeleteButton } from "@/components/DeleteButton";
import { CommentSection } from "@/components/CommentSection";
import { deletePost } from "@/app/actions/post";

const COMMENTS_PER_PAGE = 10;

export default async function PostPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ comments_page?: string }>;
}) {
  const { id } = await params;
  const { comments_page } = await searchParams;
  const postId = parseInt(id, 10);
  if (isNaN(postId)) notFound();

  const post = await prisma.post.findUnique({
    where: { id: postId },
    include: { user: true },
  });
  if (!post) notFound();

  const commentsPage = Math.max(1, parseInt(comments_page ?? "1", 10));
  const skip = (commentsPage - 1) * COMMENTS_PER_PAGE;

  const [topComments, totalComments] = await Promise.all([
    prisma.comment.findMany({
      where: { postId, parentId: null },
      include: {
        user: true,
        replies: {
          include: {
            user: true,
            replies: { include: { user: true }, orderBy: { createdAt: "desc" } },
          },
          orderBy: { createdAt: "desc" },
        },
      },
      orderBy: { createdAt: "desc" },
      take: COMMENTS_PER_PAGE,
      skip,
    }),
    prisma.comment.count({ where: { postId, parentId: null } }),
  ]);

  const totalCommentPages = Math.ceil(totalComments / COMMENTS_PER_PAGE);
  const user = await getSession();

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="bg-white shadow overflow-hidden sm:rounded-lg">
        <div className="px-4 py-5 sm:px-6 flex justify-between items-start">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">{post.title}</h1>
            <p className="mt-1 text-sm text-gray-500">
              작성자: {post.user.emailAddress} |{" "}
              {new Date(post.createdAt).toLocaleString("ko-KR")}
            </p>
          </div>
          {user?.id === post.userId && (
            <div className="flex space-x-2">
              <Link
                href={`/posts/${post.id}/edit`}
                className="inline-flex items-center px-3 py-2 border border-gray-300 shadow-sm text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
              >
                <PencilSquareIcon className="w-4 h-4 mr-1" />
                수정
              </Link>
              <form action={deletePost}>
                <input type="hidden" name="id" value={post.id} />
                <DeleteButton />
              </form>
            </div>
          )}
        </div>
        <div className="border-t border-gray-200 px-4 py-5 sm:px-6">
          <div className="prose max-w-none whitespace-pre-wrap">{post.body}</div>
        </div>
      </div>

      <div className="mt-6">
        <Link href="/posts" className="text-indigo-600 hover:text-indigo-500">
          ← 목록으로
        </Link>
      </div>

      <div className="mt-8 border-t border-gray-200 pt-8">
        <h2 className="text-2xl font-bold text-gray-900 mb-6">
          댓글 <span className="text-indigo-600">{totalComments}</span>개
        </h2>
        <CommentSection
          postId={post.id}
          comments={topComments}
          user={user}
          commentsPage={commentsPage}
          totalCommentPages={totalCommentPages}
        />
      </div>
    </div>
  );
}
