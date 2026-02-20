import type { Metadata } from "next";
import "./globals.css";
import { Nav } from "@/components/Nav";
import { FlashProvider } from "@/components/FlashProvider";

export const metadata: Metadata = {
  title: "Simple Community",
  description: "커뮤니티 게시판",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko">
      <body className="antialiased font-sans">
        <Nav />
        <FlashProvider />
        {children}
      </body>
    </html>
  );
}
