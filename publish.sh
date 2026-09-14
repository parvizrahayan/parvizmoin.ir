#!/bin/bash
# publish.sh — انتشار/به‌روزرسانی ریپوی parvizmoin.ir روی GitHub Pages
# پیش‌نیاز: gh CLI نصب و لاگین‌شده (gh auth login) — یک‌بار در ابتدای کار
set -e

REPO_NAME="parvizmoin.ir"
GH_USER="parvizrahayan"

if [ ! -d ".git" ]; then
  echo "→ ریپوی جدید، در حال init..."
  git init
  git add .
  git commit -m "publish: $REPO_NAME"
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
  gh api -X PUT "repos/$GH_USER/$REPO_NAME/pages" -f "source[branch]=main" -f "source[path]=/" || \
  gh api -X POST "repos/$GH_USER/$REPO_NAME/pages" -f "source[branch]=main" -f "source[path]=/"
  echo "✓ منتشر شد: https://$GH_USER.github.io/$REPO_NAME/"
else
  echo "→ ریپوی موجود، در حال commit و push تغییرات..."
  git add .
  git commit -m "update: $(date '+%Y-%m-%d %H:%M')" || echo "چیزی برای commit نبود."
  git push
  echo "✓ به‌روزرسانی ارسال شد."
fi
