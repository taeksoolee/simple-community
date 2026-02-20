"use client";

import { useEffect, useState } from "react";
import { XMarkIcon } from "@heroicons/react/24/outline";

type Flash = { type: "notice" | "alert"; message: string } | null;

export function FlashProvider() {
  const [flash, setFlash] = useState<Flash>(null);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    if (!mounted) return;
    fetch("/api/flash")
      .then((r) => r.json())
      .then((data) => {
        if (data.notice) setFlash({ type: "notice", message: data.notice });
        else if (data.alert) setFlash({ type: "alert", message: data.alert });
      })
      .catch(() => {});
  }, [mounted]);

  useEffect(() => {
    if (!flash || flash.type !== "notice") return;
    const t = setTimeout(() => setFlash(null), 5000);
    return () => clearTimeout(t);
  }, [flash]);

  if (!flash) return null;

  const isNotice = flash.type === "notice";

  return (
    <div
      className="fixed top-20 right-4 z-50 w-full max-w-xs flex flex-col gap-2 pointer-events-none [&>*]:pointer-events-auto"
    >
      <div
        className={`flex items-start gap-3 rounded-lg border px-4 py-3 shadow-lg backdrop-blur bg-white/95 dark:bg-gray-800/95 ${
          isNotice
            ? "border-green-200 dark:border-green-800 text-green-800 dark:text-green-200"
            : "border-red-200 dark:border-red-800 text-red-800 dark:text-red-200"
        }`}
        style={{
          animation: "slideIn 0.2s ease-out",
          opacity: flash ? 1 : 0,
          transform: flash ? "translateX(0)" : "translateX(1rem)",
        }}
      >
        <p className="flex-1 text-sm font-medium">{flash.message}</p>
        <button
          type="button"
          onClick={() => setFlash(null)}
          className={`flex-shrink-0 p-1 rounded-md transition-colors ${
            isNotice
              ? "text-green-600 hover:bg-green-50"
              : "text-red-500 hover:bg-red-50"
          }`}
          aria-label="닫기"
        >
          <XMarkIcon className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}
