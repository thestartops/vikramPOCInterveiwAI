#!/usr/bin/env bash
# Creates (or reuses) the local Kind cluster for the llm-gateway POC, then
# refuses to continue unless kubectl is actually pointed at it - added after
# we found kubectl silently sitting on the Skyler prod context earlier.
#
# Usage: ./scripts/setup-kind-cluster.sh

set -euo pipefail

CLUSTER_NAME="llm-gateway"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIND_CONFIG="${SCRIPT_DIR}/../infra/kind/kind-config.yaml"
EXPECTED_CONTEXT="kind-${CLUSTER_NAME}"

echo "==> checking docker is reachable"
if ! docker info >/dev/null 2>&1; then
  echo "ERROR: docker daemon not reachable (is Docker running? do you have permission - docker group/sudo?)." >&2
  exit 1
fi

echo "==> checking for existing kind cluster '${CLUSTER_NAME}'"
if kind get clusters 2>/dev/null | grep -qx "${CLUSTER_NAME}"; then
  echo "cluster '${CLUSTER_NAME}' already exists, skipping create"
else
  echo "==> creating kind cluster '${CLUSTER_NAME}'"
  kind create cluster --config "${KIND_CONFIG}"
fi

echo "==> switching kubectl context to ${EXPECTED_CONTEXT}"
kubectl config use-context "${EXPECTED_CONTEXT}"

echo "==> verifying context"
current_context="$(kubectl config current-context)"
if [[ "${current_context}" != "${EXPECTED_CONTEXT}" ]]; then
  echo "ERROR: current-context is '${current_context}', expected '${EXPECTED_CONTEXT}'." >&2
  echo "Refusing to continue - do not run any further kubectl/helm commands until this is fixed." >&2
  exit 1
fi
echo "OK: kubectl context is '${current_context}'"

echo "==> node status"
kubectl get nodes

echo ""
echo "Kind cluster '${CLUSTER_NAME}' is up and kubectl is pointed at it."
