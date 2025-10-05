#!/bin/bash

# アーティファクト構成証明検証スクリプト
# Usage: ./verify-attestations.sh

set -e

REPO="moulongzhang/moulongzhang.github.io"
REGISTRY="ghcr.io"
IMAGE_NAME="${REGISTRY}/${REPO}"

echo "🔍 アーティファクト構成証明の検証を開始します..."
echo ""

# GitHub CLIがインストールされているか確認
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLIがインストールされていません"
    echo "インストール方法: brew install gh"
    exit 1
fi

# GitHub CLIで認証されているか確認
if ! gh auth status &> /dev/null; then
    echo "⚠️  GitHub CLIで認証が必要です"
    echo "実行コマンド: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI認証完了"
echo ""

# 1. バイナリ成果物の検証（存在する場合）
echo "📦 バイナリ成果物の検証..."
if [ -f "website-artifact.tar.gz" ]; then
    echo "  - ビルド実績証明を検証中..."
    if gh attestation verify website-artifact.tar.gz -R "$REPO" 2>/dev/null; then
        echo "  ✅ ビルド実績証明の検証成功"
    else
        echo "  ⚠️  ビルド実績証明が見つからないか、検証に失敗しました"
    fi
    
    echo "  - SBOM構成証明 (SPDX) を検証中..."
    if gh attestation verify website-artifact.tar.gz -R "$REPO" \
        --predicate-type https://spdx.dev/Document/v2.3 2>/dev/null; then
        echo "  ✅ SBOM構成証明 (SPDX) の検証成功"
    else
        echo "  ⚠️  SBOM構成証明 (SPDX) が見つからないか、検証に失敗しました"
    fi
    
    echo "  - SBOM構成証明 (CycloneDX) を検証中..."
    if gh attestation verify website-artifact.tar.gz -R "$REPO" \
        --predicate-type https://cyclonedx.org/bom/v1.5 2>/dev/null; then
        echo "  ✅ SBOM構成証明 (CycloneDX) の検証成功"
    else
        echo "  ⚠️  SBOM構成証明 (CycloneDX) が見つからないか、検証に失敗しました"
    fi
else
    echo "  ⚠️  website-artifact.tar.gz が見つかりません"
    echo "  ヒント: GitHub Actionsから成果物をダウンロードしてください"
    echo "         gh run download --repo ${REPO}"
fi

echo ""

# 2. コンテナイメージの検証
echo "🐳 コンテナイメージの検証..."
echo "  - 利用可能なタグを確認中..."

# 最新のmainブランチイメージを検証
echo "  - イメージ: ${IMAGE_NAME}:main"
if gh attestation verify "oci://${IMAGE_NAME}:main" -R "$REPO" 2>/dev/null; then
    echo "  ✅ コンテナイメージ構成証明の検証成功"
else
    echo "  ⚠️  コンテナイメージ構成証明が見つからないか、検証に失敗しました"
    echo "  ヒント: まずワークフローを実行してイメージを構築してください"
fi

echo ""
echo "✨ 検証プロセス完了"
echo ""
echo "📚 詳細情報:"
echo "  - ドキュメント: ATTESTATION.md"
echo "  - リポジトリ: https://github.com/${REPO}"
echo "  - Actions: https://github.com/${REPO}/actions"
