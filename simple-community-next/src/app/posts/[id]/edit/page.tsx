import { notFound, redirect } from "next/navigation";
import Link from "next/link";
import { getSession } from "@/lib/auth";
import { prisma } from "@/lib/db";
import { PostForm } from "@/components/PostForm";
import { updatePost } from "@/app/actions/post";

export default async function EditPostPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const user = await getSession();
  if (!user) redirect("/login");

  const { id } = await params;
  const postId = parseInt(id, 10);
  if (isNaN(postId)) notFound();

  const post = await prisma.post.findUnique({ where: { id: postId } });
  if (!post || post.userId !== user.id) notFound();

  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <h1 className="text-3xl font-bold text-gray-900 mb-6">글 수정</h1>
      <PostForm
        action={updatePost}
        initialTitle={post.title}
        initialBody={post.body}
        hiddenFields={<input type="hidden" name="id" value={post.id} />}
      />
      <p className="mt-4">
        <Link href={`/posts/${post.id}`} className="text-indigo-600 hover:text-indigo-500">
          ← 목록으로
        </Link>
      </p>
    </div>
  );
}
