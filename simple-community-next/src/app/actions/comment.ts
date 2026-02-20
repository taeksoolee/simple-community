"use server";

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { getSession } from "@/lib/auth";
import { redirectWithNotice, redirectWithAlert } from "@/lib/flash";

export async function createComment(formData: FormData) {
  const user = await getSession();
  if (!user) redirect("/login");

  const postId = parseInt(formData.get("post_id") as string, 10);
  const parentIdRaw = formData.get("parent_id");
  const parentId = parentIdRaw ? parseInt(parentIdRaw as string, 10) : null;
  const body = formData.get("body") as string;

  if (!postId || !body?.trim()) {
    return redirect(`/posts/${postId}`);
  }

  await prisma.comment.create({
    data: {
      body: body.trim(),
      userId: user.id,
      postId,
      parentId,
    },
  });

  revalidatePath(`/posts/${postId}`);
  return redirectWithNotice(`/posts/${postId}`, "댓글이 작성되었습니다");
}

export async function deleteComment(formData: FormData) {
  const id = parseInt(formData.get("id") as string, 10);
  const user = await getSession();
  if (!user) redirect("/");

  const comment = await prisma.comment.findUnique({
    where: { id },
    include: { post: true },
  });
  if (!comment || comment.userId !== user.id) {
    return redirectWithAlert("/", "권한이 없습니다");
  }

  await prisma.comment.delete({ where: { id } });
  revalidatePath(`/posts/${comment.postId}`);
  return redirectWithNotice(`/posts/${comment.postId}`, "댓글이 삭제되었습니다");
}
