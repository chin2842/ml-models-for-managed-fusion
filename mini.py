import logging
import os

from transformers import AutoTokenizer, AutoModel
from torch.nn import functional as F
from typing import Iterable
import numpy as np
import torch

log = logging.getLogger()

class mini():
    def __init__(self):
        # Set the TRANSFORMERS_CACHE environment variable to a system-wide location
        os.environ["HF_HOME"] = "C:\\ProgramData\\transformers"

        self.tokenizer = AutoTokenizer.from_pretrained('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2')
        self.model= AutoModel.from_pretrained('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2')

    #Mean Pooling
    def mean_pooling(self, model_output, attention_mask):
        token_embeddings = model_output[0] #First element of model_output contains all token embeddings
        input_mask_expanded = attention_mask.unsqueeze(-1).expand(token_embeddings.size()).float()
        return torch.sum(token_embeddings * input_mask_expanded, 1) / torch.clamp(input_mask_expanded.sum(1), min=1e-9)

    def predict(self, X:np.ndarray, names=None, **kwargs):
        #   In Managed Fusion there are several variables passed in the numpy array with the Milvus Query stage,
        #   Encode to Milvus index stage, and Vectorize Seldon index and query stage:
        #   [pipeline, bool, and text]. Text is what variable will be encoded, so that is what will be set to 'text'
        #   When using the Machine Learning stage, the input map keys should match what what is in this file.

        model_input = dict(zip(names, X))
        text = model_input["text"]

        with torch.inference_mode(): # Allows torch to run more quickly
            # Tokenize sentences
            encoded_input = self.tokenizer(text, padding=True, truncation=True, return_tensors='pt')
            log.debug('encoded input',str(encoded_input))
            model_output = self.model(**encoded_input)
            log.debug('model output',str(model_output))

            # Perform pooling. In this case, max pooling.
            sentence_embeddings = self.mean_pooling(model_output, encoded_input['attention_mask'])
            # Normalize embeddings, because Managed Fusion likes it that way.
            sentence_embeddings = F.normalize(sentence_embeddings, p=2, dim=-1)
            # Fixing the shape of the emebbedings to match (1, 384).
            final = [sentence_embeddings.squeeze().cpu().detach().numpy().tolist()]
        return final

    def class_names(self) -> Iterable[str]:
        return ["vector"]