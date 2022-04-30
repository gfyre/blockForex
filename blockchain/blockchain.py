from ast import Str
import datetime as _dt
import hashlib as _hashlib
import json as _json
from tokenize import String
from xmlrpc.client import Boolean


class Blockchain:
    def __init__(self):
        self.chain = list()
        initial_block = self._create_block(
            type_data="genesis block", 
            Qty="0",
            order_type = "Buy",
            proof=1, 
            previous_hash="0", 
            index=1
        )
        self.chain.append(initial_block)

    def mine_block(self, type_data: str, order_type:str, Qty:int ) -> dict:
        previous_block = self.get_previous_block()
        previous_proof = previous_block["proof"]
        index = len(self.chain) + 1
        proof = self._proof_of_work(
            previous_proof=previous_proof, index=index, type_data=type_data, Qty=Qty, order_type=order_type
        )
        previous_hash = self._hash(block=previous_block)
        block = self._create_block(
            type_data=type_data, proof=proof, previous_hash=previous_hash, index=index,  Qty=Qty, order_type=order_type 
        )
        self.chain.append(block)
        return block

    def _create_block(
        self, type_data: str, proof: int, previous_hash: str, index: int, order_type:str, Qty:int 
    ) -> dict:
        block = {
            "index": index,
            "timestamp": str(_dt.datetime.now()),
            "Currency_pair": type_data,
            "Order Type": order_type,
            "Qty":str(Qty), 
            "proof": proof,
            "previous_hash": previous_hash,
        }

        return block

    def get_previous_block(self) -> dict:
        return self.chain[-1]

    def _to_digest(
        self, new_proof: int, previous_proof: int, index: int, type_data: str, order_type:str, Qty:int 
    ) -> bytes:
        to_digest = str(new_proof ** 2 - previous_proof ** 2 + index) + type_data + order_type + str(Qty) 
        # It returns an utf-8 encoded version of the string
        return to_digest.encode()

    def _proof_of_work(self, previous_proof: str, index: int, type_data: str, order_type:str, Qty:int ) -> int:
        new_proof = 1
        check_proof = False

        while not check_proof:
            to_digest = self._to_digest(new_proof, previous_proof, index, type_data, order_type, str(Qty))
            hash_operation = _hashlib.sha256(to_digest).hexdigest()
            if hash_operation[:4] == "0000":
                check_proof = True
            else:
                new_proof += 1

        return new_proof

    def _hash(self, block: dict) -> str:
        """
        Hash a block and return the crytographic hash of the block
        """
        encoded_block = _json.dumps(block, sort_keys=True).encode()

        return _hashlib.sha256(encoded_block).hexdigest()

    def is_chain_valid(self) -> bool:
        previous_block = self.chain[0]
        block_index = 1

        while block_index < len(self.chain):
            block = self.chain[block_index]
            # Check if the previous hash of the current block is the same as the hash of it's previous block
            if block["previous_hash"] != self._hash(previous_block):
                return False

            previous_proof = previous_block["proof"]
            index, type_data, proof, order_type, Qty = block["index"], block["Currency_pair"], block["proof"], block["Order Type"], block["Qty"]
            hash_operation = _hashlib.sha256(
                self._to_digest(
                    new_proof=proof,
                    previous_proof=previous_proof,
                    index=index,
                    type_data=type_data,
                    order_type=order_type,
                    Qty=str(Qty),
                )
            ).hexdigest()

            if hash_operation[:4] != "0000":
                return False

            previous_block = block
            block_index += 1

        return True