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
    <html lang="ko" suppressHydrationWarning>
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `(function(){var t=document.documentElement.classList;var s=localStorage.getItem('theme');var d=window.matchMedia('(prefers-color-scheme: dark)').matches;var dark=s==='dark'||(!s&&d);t.toggle('dark',dark);})();`,
          }}
        />
      </head>
      <body className="antialiased font-sans bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100 min-h-screen">
        <Nav />
        <FlashProvider />
        {children}
      </body>
    </html>
  );
}
