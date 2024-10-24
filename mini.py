import logging
import os
from transformers import AutoTokenizer, AutoModel
from torch.nn import functional as F
from typing import Iterable
import numpy as np
import torch

log = logging.getLogger()

class App():  # Class renamed to match the entry point
    def __init__(self):
        self.tokenizer = AutoTokenizer.from_pretrained('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2')
        self.model = AutoModel.from_pretrained('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2')

    # Mean Pooling
    def mean_pooling(self, model_output, attention_mask):
        token_embeddings = model_output[0]
        input_mask_expanded = attention_mask.unsqueeze(-1).expand(token_embeddings.size()).float()
        return torch.sum(token_embeddings * input_mask_expanded, 1) / torch.clamp(input_mask_expanded.sum(1), min=1e-9)

    def predict(self, X: np.ndarray, names=None, **kwargs):
        model_input = dict(zip(names, X))
        text = model_input["text"]

        with torch.inference_mode():
            encoded_input = self.tokenizer(text, padding=True, truncation=True, return_tensors='pt')
            model_output = self.model(**encoded_input)
            sentence_embeddings = self.mean_pooling(model_output, encoded_input['attention_mask'])
            sentence_embeddings = F.normalize(sentence_embeddings, p=2, dim=-1)
            final = [sentence_embeddings.squeeze().cpu().detach().numpy().tolist()]
        return final

    def class_names(self) -> Iterable[str]:
        return ["vector"]

if __name__ == "__main__":
    model = App()  # Instantiate the class