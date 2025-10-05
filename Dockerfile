# ベースイメージ
FROM node:18-alpine AS builder

# 作業ディレクトリを設定
WORKDIR /app

# package.jsonとpackage-lock.jsonをコピー
COPY package*.json ./

# 依存関係をインストール
RUN npm ci --only=production

# アプリケーションファイルをコピー
COPY . .

# 本番用イメージ
FROM nginx:alpine

# Nginxの設定ファイルをコピー
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/*.js /usr/share/nginx/html/

# ポート80を公開
EXPOSE 80

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Nginxを起動
CMD ["nginx", "-g", "daemon off;"]
