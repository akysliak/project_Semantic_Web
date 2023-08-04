package mswQuery;

import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.util.FileManager;
import java.util.HashMap;
import java.util.LinkedList;

/**
 *
 * @author Anastasiia Kysliak
 */
public class MSWQuery {
    private static final String ONTOLOGY = Ontology.ONTOLOGY;
    private static String LABELS = Ontology.LABELS + "en" + Ontology.LABELS_FORMAT;;
    private static final Model MODEL = FileManager.get().loadModel(ONTOLOGY);
    private static Model LABELS_MODEL = null;

    public static void setLocale(String locale) {
        LABELS = Ontology.LABELS + locale + Ontology.LABELS_FORMAT;
        LABELS_MODEL = FileManager.get().loadModel(LABELS);
    }
    public static String getLabel(String ontology_entry) {
            String queryString = IRIs.QUERYHEADER +
                "SELECT DISTINCT ?l WHERE { " +
                "ont:" + ontology_entry + " rdfs:label ?l . " +
                "} ORDER BY(?l)";
        return processGetLabel(queryString, "l");
    }
    private static String processGetLabel (String queryString, String varName) {
        LinkedList<String> res = new LinkedList<String>();
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.create(query, LABELS_MODEL);
        try {
            ResultSet results = qexec.execSelect();
            while (results.hasNext() ) {
                    QuerySolution qs = results.nextSolution();
                    String str = qs.get(varName).toString();
                    res.add(str);
            }
        } finally {
            qexec.close();
        }
        return res.getFirst();
    }
    public static LinkedList<String> getScientificNamesList() {
        String queryString = IRIs.QUERYHEADER +
                "SELECT DISTINCT ?o WHERE { " +
                "?s ont:scientific_name ?o . " +
                "} ORDER BY(?o)";
        return getList(queryString, "o");
    }

    public static HashMap<String, LinkedList<String>> searchByScientificName(String scName, String[] properties) {
        if(scName.isEmpty()) {
            return null;
        }
        String filter = "FILTER (";
        for(int i = 0, n = properties.length; i < n; ++i) {
            filter += ("?property = ont:" + properties[i]);
            filter += ( i==n-1? ") " : " || " );
        }
        String queryString = IRIs.QUERYHEADER +
                "SELECT ?property ?value WHERE { " +
                "?x ont:scientific_name \"" + scName + "\" . " +
                "?x ?property ?value . " +
                filter +
                "} ORDER BY(?property)";
        return getQueryResultsAsHashMap(queryString);
    }


    public static LinkedList<String> getAllNamesList () {
        String queryString = IRIs.QUERYHEADER +
                "SELECT DISTINCT ?o WHERE { " +
                "?s ?p ?o . " +
                "FILTER (?p = ont:scientific_name || ?p = ont:common_name || ?p = ont:synonym)" +
                "} ORDER BY(?o)";
        return getList(queryString, "o");
    }
    public static LinkedList<String> getPropertiesList() {
        String queryString = IRIs.QUERYHEADER +
                "SELECT DISTINCT ?x WHERE { " +
                "?s ?x ?o . " +
                "?s rdf:type owl:NamedIndividual . " +
                "} ORDER BY(?x)";
        return getList(queryString, "x");
    }

    public static LinkedList<String> getValuesList(String property) {
        if(property.isEmpty()) {
            return new LinkedList<String>();
        }
        String queryString = IRIs.QUERYHEADER +
                "SELECT DISTINCT ?x WHERE { " +
                "?s ont:" + property + " ?x ." +
                "?s rdf:type owl:NamedIndividual . " +
                "}";
        return getList(queryString, "x");
    }

    public static LinkedList<String> searchByPropertyValue(String property, String value) {
        String queryString = IRIs.QUERYHEADER +
                "SELECT ?x WHERE { " +
                "?s ont:scientific_name ?x . " +
                "?s ont:" + property + " ?o " +
                "FILTER ( ?o = ont:" + value + " || " + "?o = \"" + value + "\") " +
                "}";
        return getList(queryString, "x");
    }
    public static LinkedList<String> searchInTaxTree(String selectedElement) {
        String queryString = IRIs.QUERYHEADER +
                "SELECT ?x WHERE { " +
                "?x rdf:type owl:NamedIndividual . " +
                "?x a ?y . " +
                "?y rdfs:subClassOf* ont:" + selectedElement + " . " +
                "} ORDER BY ?x";
        return getList(queryString, "x");
    }

    private static LinkedList<String> getList(String queryString, String varName) {
        LinkedList<String> res = new LinkedList<String>();
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.create(query, MODEL);
        try {
            ResultSet results = qexec.execSelect();
            while (results.hasNext() ) {
                    QuerySolution qs = results.nextSolution();
                    String str = qs.get(varName).toString();
                    res.add(IRIs.getShortNameFromIRI(str));
            }
        } finally {
            qexec.close();
        }
        return res;
    }

    private static HashMap<String, LinkedList<String>> getQueryResultsAsHashMap(String queryString){
        HashMap<String, LinkedList<String>> res = new HashMap<String, LinkedList<String>>();
        Query query = QueryFactory.create(queryString);
        QueryExecution qexec = QueryExecutionFactory.create(query, MODEL);
        try {
            ResultSet results = qexec.execSelect();
            String prev_prop = "";
            String cur_prop = "";
            LinkedList<String> values = new LinkedList<String>();
            while (results.hasNext() ) {
                    QuerySolution sol = results.nextSolution();
                    cur_prop = sol.get("property").toString();
                    String value = sol.get("value").toString();
                    if(cur_prop.contains("#")) {
                        cur_prop = cur_prop.substring(cur_prop.indexOf("#")+1);
                    }
                    if(value.contains("#")) {
                        value = value.substring(value.indexOf("#")+1);
                    }
                    if (!cur_prop.equals(prev_prop) && !prev_prop.isEmpty()){
                        res.put(prev_prop, values);
                        values = new LinkedList<String>();
                    }
                    prev_prop = cur_prop;
                    values.add(value);
                    if(!results.hasNext()) {
                        res.put(cur_prop, values);
                    }
            }
        } finally {
            qexec.close();
        }
        return res;
    }

    public static LinkedList<String> getTaxTreeLevelList(String ttLevel) {
        String taxTreeLevel = ttLevel.toLowerCase();
        String queryString = IRIs.QUERYHEADER +
                "SELECT ?s WHERE { " +
                "?s rdfs:comment \"" + taxTreeLevel + "\" ." +
                "} ORDER BY ?s";
        return getList(queryString, "s");
    }
    public static LinkedList<String> getTaxTreeLevelList(String searchedTTLevel, String selectedElement) {
        if (selectedElement.isEmpty()) {
            return getTaxTreeLevelList(searchedTTLevel);
        }
        String searchedTTLev = searchedTTLevel.toLowerCase();
        String queryString = IRIs.QUERYHEADER +
                "SELECT ?s WHERE { " +
                "?s rdfs:comment \"" + searchedTTLev + "\" . " +
                "?s rdfs:subClassOf*  ont:" + selectedElement + " . " +
                "} ORDER BY ?s";
        return getList(queryString, "s");
    }
    public static LinkedList<String> getTaxTreeLevelForAncestor(String searchedTTLevel, String selectedElement) {
        String searchedTTLev = searchedTTLevel.toLowerCase();
        String queryString = IRIs.QUERYHEADER +
                "SELECT ?s WHERE { " +
                "?s rdfs:comment \"" + searchedTTLev + "\" . " +
                "ont:" + selectedElement + " rdfs:subClassOf* ?s . " +
                "} ORDER BY ?s";
        return getList(queryString, "s");
    }
}
