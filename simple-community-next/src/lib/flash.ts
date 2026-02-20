import { cookies } from "next/headers";
import { redirect } from "next/navigation";

export async function redirectWithNotice(path: string, message: string) {
  (await cookies()).set("flash_notice", message, {
    path: "/",
    maxAge: 1,
  });
  redirect(path);
}

export async function redirectWithAlert(path: string, message: string) {
  (await cookies()).set("flash_alert", message, {
    path: "/",
    maxAge: 1,
  });
  redirect(path);
}
