import { redirect } from "next/navigation";
import Link from "next/link";
import { getSession } from "@/lib/auth";
import { PostForm } from "@/components/PostForm";
import { createPost } from "@/app/actions/post";

export default async function NewPostPage() {
  const user = await getSession();
  if (!user) redirect("/login");

  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <h1 className="text-3xl font-bold text-gray-900 mb-6">새 글 작성</h1>
      <PostForm action={createPost} />
      <p className="mt-4">
        <Link href="/posts" className="text-indigo-600 hover:text-indigo-500">
          ← 목록으로
        </Link>
      </p>
    </div>
  );
}
