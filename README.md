# moulongzhang.github.io

## 概要
このリポジトリは、GitHub Actionsのセキュリティ機能のデモンストレーションプロジェクトです。

## 実装されているセキュリティ機能

### 🔐 Artifact Attestation（アーティファクト構成証明）
ビルド成果物とコンテナイメージの構成証明を自動生成し、サプライチェーンのセキュリティを強化しています。

- ✅ ビルド実績証明 (Build Provenance)
- ✅ SBOM構成証明 (Software Bill of Materials)
- ✅ コンテナイメージ構成証明

詳細は [ATTESTATION.md](./ATTESTATION.md) をご覧ください。

### 🔍 CodeQL
コードの静的解析によるセキュリティ脆弱性の検出

### 🤖 Dependabot
依存関係の脆弱性を自動検出し、更新プルリクエストを作成

### 🔑 Secret Scanning
コミットされたシークレットの検出と警告

## ワークフロー

- **Build and Attest** (`.github/workflows/build-and-attest.yml`): ビルド成果物の構成証明生成
- **Docker Attest** (`.github/workflows/docker-attest.yml`): コンテナイメージの構成証明生成
- **ESLint** (`.github/workflows/eslint.yml`): コード品質チェック

## セットアップ

```bash
# 依存関係のインストール
npm install

# 開発サーバーの起動
npm start
```

## 構成証明の検証

```bash
# GitHub CLIで構成証明を検証
gh attestation verify website-artifact.tar.gz -R moulongzhang/moulongzhang.github.io

# コンテナイメージの検証
gh attestation verify oci://ghcr.io/moulongzhang/moulongzhang.github.io:main -R moulongzhang/moulongzhang.github.io
```

## ライセンス
MIT License
