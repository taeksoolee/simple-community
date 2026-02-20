"use client";

import Link from "next/link";
import { useState } from "react";
import { ChatBubbleLeftIcon, PencilSquareIcon, LockClosedIcon } from "@heroicons/react/24/outline";
import { createComment, deleteComment } from "@/app/actions/comment";
import type { User, Comment } from "@prisma/client";

type CommentWithReplies = Comment & {
  user: User;
  replies: CommentWithReplies[];
};

export function CommentSection({
  postId,
  comments,
  user,
  commentsPage,
  totalCommentPages,
}: {
  postId: number;
  comments: CommentWithReplies[];
  user: User | null;
  commentsPage: number;
  totalCommentPages: number;
}) {
  return (
    <div className="mb-8">
      {comments.length > 0 ? (
        <div className="space-y-4">
          {comments.map((comment) => (
            <CommentItem key={comment.id} comment={comment} user={user} postId={postId} depth={0} />
          ))}
        </div>
      ) : (
        <div className="text-center py-12 bg-gray-50 rounded-lg">
          <ChatBubbleLeftIcon className="mx-auto h-12 w-12 text-gray-400" />
          <p className="mt-4 text-gray-500 text-lg">아직 댓글이 없습니다</p>
          <p className="mt-2 text-gray-400 text-sm">첫 댓글을 작성해보세요!</p>
        </div>
      )}

      {totalCommentPages > 1 && (
        <div className="mt-6 flex justify-center gap-2">
          {commentsPage > 1 && (
            <Link
              href={`/posts/${postId}?comments_page=${commentsPage - 1}`}
              className="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
            >
              ← 이전
            </Link>
          )}
          {Array.from({ length: totalCommentPages }, (_, i) => i + 1).map((p) => (
            <Link
              key={p}
              href={`/posts/${postId}?comments_page=${p}`}
              className={`px-3 py-2 text-sm font-medium rounded-md ${
                p === commentsPage ? "text-white bg-indigo-600" : "text-gray-700 bg-white border border-gray-300 hover:bg-gray-50"
              }`}
            >
              {p}
            </Link>
          ))}
          {commentsPage < totalCommentPages && (
            <Link
              href={`/posts/${postId}?comments_page=${commentsPage + 1}`}
              className="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
            >
              다음 →
            </Link>
          )}
        </div>
      )}

      <div className="mt-8 sticky bottom-0 bg-white border-t-2 border-gray-200 pt-6">
        {user ? (
          <div className="bg-white rounded-lg border-2 border-indigo-200 shadow-lg">
            <div className="bg-gradient-to-r from-indigo-50 to-blue-50 px-6 py-3 border-b border-indigo-100">
              <h3 className="text-lg font-semibold text-gray-800 flex items-center">
                <PencilSquareIcon className="w-5 h-5 mr-2 text-indigo-600" />
                댓글 작성
              </h3>
            </div>
            <form action={createComment} className="p-6 space-y-4">
              <input type="hidden" name="post_id" value={postId} />
              <textarea
                name="body"
                rows={4}
                required
                className="block w-full px-4 py-3 rounded-lg border-2 border-gray-300 placeholder-gray-400 focus:outline-none focus:border-indigo-500 sm:text-sm resize-none"
                placeholder="댓글을 입력하세요..."
              />
              <div className="flex items-center justify-between">
                <p className="text-sm text-gray-500">
                  <span className="font-medium text-gray-700">{user.emailAddress}</span> 님으로 댓글 작성
                </p>
                <button
                  type="submit"
                  className="px-6 py-3 border border-transparent text-sm font-semibold rounded-lg text-white bg-indigo-600 hover:bg-indigo-700"
                >
                  댓글 등록
                </button>
              </div>
            </form>
          </div>
        ) : (
          <div className="p-8 bg-gradient-to-r from-indigo-50 via-blue-50 to-purple-50 rounded-lg border-2 border-indigo-200 shadow-md text-center">
            <LockClosedIcon className="mx-auto h-10 w-10 text-indigo-400 mb-4" />
            <p className="text-gray-800 text-lg font-semibold mb-2">댓글을 작성하려면 로그인이 필요합니다</p>
            <p className="text-gray-600 mb-4">로그인하고 다른 사용자들과 소통해보세요</p>
            <div className="flex justify-center gap-3">
              <Link
                href="/login"
                className="inline-flex items-center px-5 py-2.5 border border-transparent text-sm font-medium rounded-lg text-white bg-indigo-600 hover:bg-indigo-700"
              >
                로그인
              </Link>
              <Link
                href="/register"
                className="inline-flex items-center px-5 py-2.5 border-2 border-indigo-600 text-sm font-medium rounded-lg text-indigo-600 bg-white hover:bg-indigo-50"
              >
                회원가입
              </Link>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

function CommentItem({
  comment,
  user,
  postId,
  depth,
}: {
  comment: CommentWithReplies;
  user: User | null;
  postId: number;
  depth: number;
}) {
  const [replyingTo, setReplyingTo] = useState<number | null>(null);

  return (
    <div className={`${depth > 0 ? "ml-8 mt-2" : ""}`}>
      <div className="bg-gray-50 rounded-lg p-4 border border-gray-200">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <p className="text-sm font-medium text-gray-900">{comment.user.emailAddress}</p>
            <p className="text-sm text-gray-500 mt-1">
              {new Date(comment.createdAt).toLocaleString("ko-KR")}
            </p>
            <p className="mt-2 text-gray-800 whitespace-pre-wrap">{comment.body}</p>
          </div>
          {user?.id === comment.userId && (
            <form action={deleteComment} className="ml-2">
              <input type="hidden" name="id" value={comment.id} />
              <button
                type="submit"
                onClick={(e) => confirm("삭제하시겠습니까?") || e.preventDefault()}
                className="text-xs text-red-600 hover:text-red-700"
              >
                삭제
              </button>
            </form>
          )}
        </div>
        {user && depth < 5 && (
          <button
            type="button"
            onClick={() => setReplyingTo(replyingTo === comment.id ? null : comment.id)}
            className="mt-2 text-sm text-indigo-600 hover:text-indigo-700"
          >
            답글
          </button>
        )}
      </div>

      {replyingTo === comment.id && user && (
        <form action={createComment} className="mt-2 ml-4 p-4 bg-white rounded-lg border border-indigo-200">
          <input type="hidden" name="post_id" value={postId} />
          <input type="hidden" name="parent_id" value={comment.id} />
          <textarea
            name="body"
            rows={3}
            required
            className="block w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:border-indigo-500 text-sm"
            placeholder="답글을 입력하세요..."
          />
          <div className="mt-2 flex gap-2">
            <button
              type="submit"
              className="px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-lg hover:bg-indigo-700"
            >
              답글 작성
            </button>
            <button
              type="button"
              onClick={() => setReplyingTo(null)}
              className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50"
            >
              취소
            </button>
          </div>
        </form>
      )}

      {comment.replies.length > 0 && (
        <div className="mt-2 space-y-2">
          {comment.replies.map((reply) => (
            <CommentItem
              key={reply.id}
              comment={reply as CommentWithReplies}
              user={user}
              postId={postId}
              depth={depth + 1}
            />
          ))}
        </div>
      )}
    </div>
  );
}
