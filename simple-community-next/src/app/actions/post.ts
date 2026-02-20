"use server";

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/db";
import { getSession } from "@/lib/auth";
import { redirectWithNotice, redirectWithAlert } from "@/lib/flash";

export async function createPost(prevOrFormData: unknown, formData?: FormData) {
  const fd = (formData ?? prevOrFormData) as FormData;
  const user = await getSession();
  if (!user) {
    redirect("/login");
  }
  const title = fd.get("title") as string;
  const body = fd.get("body") as string;

  if (!title?.trim()) {
    return { error: "제목을 입력하세요" };
  }
  if (!body?.trim()) {
    return { error: "내용을 입력하세요" };
  }

  await prisma.post.create({
    data: {
      title: title.trim(),
      body: body.trim(),
      userId: user.id,
    },
  });
  revalidatePath("/");
  revalidatePath("/posts");
  return redirectWithNotice("/posts", "게시글이 작성되었습니다");
}

export async function updatePost(prevOrFormData: unknown, formData?: FormData) {
  const fd = (formData ?? prevOrFormData) as FormData;
  const user = await getSession();
  if (!user) redirect("/login");

  const id = parseInt(fd.get("id") as string, 10);
  const post = await prisma.post.findUnique({ where: { id } });
  if (!post || post.userId !== user.id) {
    return redirectWithAlert("/posts", "권한이 없습니다");
  }

  const title = fd.get("title") as string;
  const body = fd.get("body") as string;

  if (!title?.trim() || !body?.trim()) {
    return { error: "제목과 내용을 입력하세요" };
  }

  await prisma.post.update({
    where: { id },
    data: { title: title!.trim(), body: body!.trim() },
  });
  revalidatePath("/");
  revalidatePath("/posts");
  revalidatePath(`/posts/${id}`);
  return redirectWithNotice(`/posts/${id}`, "게시글이 수정되었습니다");
}

export async function deletePost(formData: FormData) {
  const id = parseInt(formData.get("id") as string, 10);
  const user = await getSession();
  if (!user) redirect("/login");

  const post = await prisma.post.findUnique({ where: { id } });
  if (!post || post.userId !== user.id) {
    return redirectWithAlert("/posts", "권한이 없습니다");
  }

  await prisma.post.delete({ where: { id } });
  revalidatePath("/");
  revalidatePath("/posts");
  return redirectWithNotice("/posts", "게시글이 삭제되었습니다");
}
