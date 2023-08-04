The files in this folder were created in course of my work on the bachelor thesis based on the
preceding research internship in Semantic Web at the NIT Kurukshetra, India. They correspond to
an implementation of a web application based on Semantic Web technology - a web portal about Indian
biodiversity. The application has a simple GUI and allows the final user to search for information
about Indian species: their scientific and common names, typical living environment. Both GUI and the
output information are localized for ***English***, ***German*** and ***Russian***. the app is design
in a way that allows an easy adding of new languages as well as functionality and more pieces of
information to be displayed. It utilizes principles of OOP.

The web pages are implemented in JavaScript while the actual application logic - in Java.
The information about the species is stored in an ontology and gets retrieved from it with
SPARQL queries which correspond to user requests.
The localization of the GUI is implemented with *Java resource bundles*. For the localization
of information related to species (the actual content of the application), 2 approaches were
followed: with *Java resource bundles* (see folder **semantic_web_portal_bundles**) and with OWL
ontology properties *rdfs:label* (see **semantic_web_portal_labels**). To easily transform Java *bundle*
files into *ttl*-files with *rdfs:label* properties for ontology entries, an extra script *coverter.py*
was created.

The data in this folder are organized as follows:

+ ***semantic_web_portal_bundles*** - files corresponding to the implementation of the web application
                                    with the usage of *Java resource bundles* for localization of
                                    ontology entries.

+ ***semantic_web_portal_labels*** - files corresponding to the implementation of the web application
                                    with the usage of *rdfs:label* property for localization of
                                    ontology entries.
+ ***coverter.py*** - an additional script to convert *bundle* files into *ttl*-files with *rdfs:label*
                    properties for ontology entries.

Both ***semantic_web_portal_bundles*** and ***semantic_web_portal_labels*** have the same structure:

- ***web*** - implementation of the web pages (interaction with the end user).

- ***src/java*** - files corresponding to the actual logic of the application, knowledge representation (ontology),
                  localization:

  - **gui** - files here support the localization of the GUI (Java *bundle* files), its correspondence
                          to the ontology structure and possible outputs, its interaction with the search engine.

  - **mswQuery** - files representing the search engine (querying the knowledge base - ontology).

  - **ontology** - contains a small example ontology in *ttl*-format as well as corresponding files
                                for localization: *Java resource bundles* in **semantic_web_portal_bundles** and
                                further *ttl* ontology files in **semantic_web_portal_labels**.

The example ontology was populated based on information from [India Biodiversity Portal](indiabiodiversity.org) and Wikipedia.
The details about the overall architecture are described in this [paper](https://www.igi-global.com/article/language-agnostic-knowledge-representation-for-a-truly-multilingual-semantic-web/297045).

Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg
