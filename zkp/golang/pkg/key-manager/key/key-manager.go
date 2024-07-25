package key

import (
	"github.com/hyperledger-labs/zeto/internal/key-manager/key"
	"github.com/hyperledger-labs/zeto/pkg/key-manager/core"
)

func NewKeyEntryFromPrivateKeyBytes(keyBytes [32]byte) *core.KeyEntry {
	return key.NewKeyEntryFromPrivateKeyBytes(keyBytes)
}
