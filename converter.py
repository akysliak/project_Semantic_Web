import re

def convert(file_to_read, file_to_write):
	res = """
@prefix : <http://www.semanticweb.org/lenovo/ontologies/2018/7/indian_biodiversity#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xml: <http://www.w3.org/XML/1998/namespace> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix ont: <http://www.semanticweb.org/lenovo/ontologies/2018/7/indian_biodiversity#> .

@base <http://www.semanticweb.org/lenovo/ontologies/2018/7/indian_biodiversity> .

<http://www.semanticweb.org/lenovo/ontologies/2018/7/indian_biodiversity> rdf:type owl:Ontology .
"""
	with open(file_to_read, "r", encoding="utf-8") as f:
		text = f.read()
	lines = text.splitlines()
	for line in lines:
		if(line.find('=') != -1):
			key, value = line.split('=')
			key = key.strip()
			value = value.strip()
			res += ("\nont:"+key+" rdfs:label \""+value+"\" . ")
	with open(file_to_write, "w", encoding="utf-8") as f2:
		f2.write(res)


if __name__ == "__main__":
	convert("labels_en.properties", "ontology_labels_en.ttl")
	convert("labels_de.properties", "ontology_labels_de.ttl")
	convert("labels_ru.properties", "ontology_labels_ru.ttl")
