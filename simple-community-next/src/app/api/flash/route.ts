import { NextResponse } from "next/server";
import { cookies } from "next/headers";

export async function GET() {
  const cookieStore = await cookies();
  const notice = cookieStore.get("flash_notice")?.value ?? null;
  const alert = cookieStore.get("flash_alert")?.value ?? null;

  const res = NextResponse.json({ notice, alert });

  if (notice || alert) {
    cookieStore.delete("flash_notice");
    cookieStore.delete("flash_alert");
  }
  return res;
}
