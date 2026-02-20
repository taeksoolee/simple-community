import Link from "next/link";
import { getSession } from "@/lib/auth";
import { signOut } from "@/app/actions/auth";
import { ThemeToggle } from "./ThemeToggle";

export async function Nav() {
  const user = await getSession();

  return (
    <nav className="bg-white dark:bg-gray-800 shadow-lg border-b border-gray-200 dark:border-gray-700">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center">
            <Link href="/" className="text-xl font-bold text-gray-800 dark:text-gray-100">
              Simple Community
            </Link>
            <Link
              href="/posts"
              className="ml-6 px-1 pt-1 text-sm font-medium text-gray-900 dark:text-gray-100"
            >
              게시판
            </Link>
          </div>
          <div className="flex items-center gap-2">
            <ThemeToggle />
            {user ? (
              <>
                <span className="text-gray-700 dark:text-gray-300 mr-2">{user.emailAddress}</span>
                <form action={signOut}>
                  <button
                    type="submit"
                    className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700"
                  >
                    로그아웃
                  </button>
                </form>
              </>
            ) : (
              <>
                <Link
                  href="/login"
                  className="inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
                >
                  로그인
                </Link>
                <Link
                  href="/register"
                  className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700"
                >
                  회원가입
                </Link>
              </>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
}
