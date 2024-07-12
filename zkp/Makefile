circuits := $(wildcard circuits/*.circom)
keys := $(patsubst circuits/%.circom,proving-keys/%-vkey.json,$(circuits))
ptau_files := $(addsuffix .ptau,$(addprefix ptau/powersOfTau28_hez_final_,11 12 13 14 15 16))

ptau_size__anon := 12
ptau_size__anon_enc := 13
ptau_size__anon_nullifier := 16
ptau_size__anon_enc_nullifier := 16
ptau_size__check_nullifiers := 11
ptau_size__nf_anon := 11
ptau_size__nf_anon_nullifier := 15

ptau_file = ptau/powersOfTau28_hez_final_$(ptau_size__$(basename $(notdir $@))).ptau

.PHONY: keys clean
.SECONDARY:

keys: $(keys)

clean:
	rm -rf ptau proving-keys

ptau/%.ptau:
	mkdir -p $(dir $@)
	curl -so $@ https://storage.googleapis.com/zkevm/$@

proving-keys/%.r1cs: circuits/%.circom
	mkdir -p $(dir $@)
	circom $< --output $(dir $@) --r1cs

proving-keys/%.zkey: proving-keys/%.r1cs $(ptau_files)
	snarkjs groth16 setup $< $(ptau_file) $@

proving-keys/%-vkey.json: proving-keys/%.zkey
	snarkjs zkey export verificationkey $< $@
