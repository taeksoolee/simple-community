"use client";

import { useActionState } from "react";

type FormAction = (prev: unknown, formData: FormData) => Promise<{ error?: string } | void>;

export function PostForm({
  action,
  initialTitle = "",
  initialBody = "",
  hiddenFields,
}: {
  action: FormAction;
  initialTitle?: string;
  initialBody?: string;
  hiddenFields?: React.ReactNode;
}) {
  const [state, formAction] = useActionState(action, null);

  return (
    <form action={formAction} className="space-y-4">
      {hiddenFields}
      {state?.error && (
        <div className="rounded-lg bg-red-50 p-4 border border-red-200">
          <p className="text-sm font-medium text-red-800">{state.error}</p>
        </div>
      )}
      <div>
        <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-2">
          제목
        </label>
        <input
          id="title"
          name="title"
          required
          defaultValue={initialTitle}
          className="block w-full px-4 py-3 rounded-lg border-2 border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 sm:text-sm"
          placeholder="제목을 입력하세요"
        />
      </div>
      <div>
        <label htmlFor="body" className="block text-sm font-medium text-gray-700 mb-2">
          내용
        </label>
        <textarea
          id="body"
          name="body"
          required
          rows={8}
          defaultValue={initialBody}
          className="block w-full px-4 py-3 rounded-lg border-2 border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 sm:text-sm"
          placeholder="내용을 입력하세요"
        />
      </div>
      <button
        type="submit"
        className="px-6 py-3 border border-transparent text-sm font-semibold rounded-lg text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
      >
        {initialTitle ? "수정" : "작성"}
      </button>
    </form>
  );
}
