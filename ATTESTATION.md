# アーティファクト構成証明 (Artifact Attestation)

このリポジトリでは、GitHub ActionsによるArtifact Attestation（アーティファクト構成証明）を実装しています。

## 概要

アーティファクト構成証明を使用すると、ソフトウェアが構築された場所と方法を確立し、構築のサプライチェーンのセキュリティを強化できます。

## 実装内容

### 1. ビルド成果物の構成証明
- **ワークフロー**: `.github/workflows/build-and-attest.yml`
- **対象**: ウェブサイトのビルド成果物 (`website-artifact.tar.gz`)
- **生成される構成証明**:
  - ビルド実績証明 (Build Provenance)
  - SBOM構成証明 (SPDX形式)
  - SBOM構成証明 (CycloneDX形式)

### 2. コンテナイメージの構成証明
- **ワークフロー**: `.github/workflows/docker-attest.yml`
- **対象**: Dockerコンテナイメージ
- **レジストリ**: GitHub Container Registry (ghcr.io)
- **生成される構成証明**:
  - イメージビルド実績証明
  - コンテナSBOM構成証明

## 構成証明の検証方法

### 前提条件
- GitHub CLIがインストールされていること
- GitHubアカウントで認証されていること

```bash
# GitHub CLIのインストール (macOS)
brew install gh

# GitHub CLIで認証
gh auth login
```

### バイナリの構成証明を検証

```bash
# ビルド成果物をダウンロード
gh run download --repo moulongzhang/moulongzhang.github.io

# 構成証明を検証
gh attestation verify website-artifact.tar.gz -R moulongzhang/moulongzhang.github.io
```

### コンテナイメージの構成証明を検証

```bash
# Container Registryにログイン
docker login ghcr.io

# イメージの構成証明を検証
gh attestation verify oci://ghcr.io/moulongzhang/moulongzhang.github.io:main \
  -R moulongzhang/moulongzhang.github.io
```

### SBOM構成証明を検証

SBOM構成証明を検証する場合は、述語タイプを指定する必要があります：

```bash
# SPDX形式のSBOM構成証明を検証
gh attestation verify website-artifact.tar.gz \
  -R moulongzhang/moulongzhang.github.io \
  --predicate-type https://spdx.dev/Document/v2.3

# CycloneDX形式のSBOM構成証明を検証
gh attestation verify website-artifact.tar.gz \
  -R moulongzhang/moulongzhang.github.io \
  --predicate-type https://cyclonedx.org/bom/v1.5

# 詳細情報をJSON形式で表示
gh attestation verify website-artifact.tar.gz \
  -R moulongzhang/moulongzhang.github.io \
  --predicate-type https://spdx.dev/Document/v2.3 \
  --format json \
  --jq '.[].verificationResult.statement.predicate'
```

## ワークフローの実行

### 自動実行
以下の場合に自動的にワークフローが実行されます：
- `main`、`master`、または `feature/*` ブランチへのpush
- `main`または`master`ブランチへのプルリクエスト

### 手動実行
GitHubのActionsタブから手動で実行することもできます：

1. リポジトリのActionsタブにアクセス
2. 実行したいワークフローを選択
3. "Run workflow"ボタンをクリック

## 構成証明の確認

生成された構成証明は、リポジトリのActionsタブで確認できます：

1. リポジトリのActionsタブにアクセス
2. 該当するワークフロー実行を選択
3. "Attestations"セクションで構成証明を確認

## セキュリティ上のメリット

1. **透明性**: ビルドプロセスの完全な記録
2. **検証可能性**: 第三者がアーティファクトの出所を検証可能
3. **改ざん検知**: アーティファクトが改変されていないことを確認
4. **コンプライアンス**: SLSA (Supply-chain Levels for Software Artifacts) フレームワークへの準拠

## 参考リンク

- [GitHub Docs - アーティファクト構成証明](https://docs.github.com/ja/actions/security-for-github-actions/using-artifact-attestations/using-artifact-attestations-to-establish-provenance-for-builds)
- [actions/attest-build-provenance](https://github.com/actions/attest-build-provenance)
- [actions/attest-sbom](https://github.com/actions/attest-sbom)
- [GitHub CLI - attestation](https://cli.github.com/manual/gh_attestation)

## トラブルシューティング

### 権限エラーが発生する場合
ワークフローに以下の権限が設定されていることを確認してください：
```yaml
permissions:
  id-token: write
  contents: read
  attestations: write
  packages: write  # コンテナイメージの場合のみ
```

### 検証に失敗する場合
- GitHub CLIが最新版であることを確認
- リポジトリ名とOrganization名が正しいことを確認
- 構成証明が正常に生成されていることをActionsタブで確認
