"use server";

import { redirect } from "next/navigation";
import { prisma } from "@/lib/db";
import { createSession, destroySession, hashPassword, verifyPassword } from "@/lib/auth";
import { redirectWithNotice } from "@/lib/flash";

export async function signUp(formData: FormData) {
  const emailAddress = formData.get("email_address") as string;
  const password = formData.get("password") as string;
  const passwordConfirmation = formData.get("password_confirmation") as string;

  if (!emailAddress?.trim()) {
    return { error: "이메일을 입력하세요" };
  }
  if (!password || password.length < 6) {
    return { error: "비밀번호는 6자 이상이어야 합니다" };
  }
  if (password !== passwordConfirmation) {
    return { error: "비밀번호가 일치하지 않습니다" };
  }

  const existing = await prisma.user.findUnique({ where: { emailAddress: emailAddress.trim() } });
  if (existing) {
    return { error: "이미 사용 중인 이메일입니다" };
  }

  const passwordDigest = await hashPassword(password);
  const user = await prisma.user.create({
    data: {
      emailAddress: emailAddress.trim(),
      passwordDigest,
    },
  });

  await createSession(user.id);
  return redirectWithNotice("/", "회원가입이 완료되었습니다");
}

export async function signIn(formData: FormData) {
  const emailAddress = formData.get("email_address") as string;
  const password = formData.get("password") as string;

  if (!emailAddress?.trim() || !password) {
    return { error: "이메일과 비밀번호를 입력하세요" };
  }

  const user = await prisma.user.findUnique({ where: { emailAddress: emailAddress.trim() } });
  if (!user || !(await verifyPassword(password, user.passwordDigest))) {
    return { error: "이메일 또는 비밀번호가 일치하지 않습니다" };
  }

  await createSession(user.id);
  return redirectWithNotice("/", "로그인 되었습니다");
}

export async function signOut() {
  await destroySession();
  return redirectWithNotice("/", "로그아웃 되었습니다");
}
