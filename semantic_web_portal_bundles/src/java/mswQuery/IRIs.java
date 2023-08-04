package mswQuery;

/**
 *
 * @author Anastasiia Kysliak
 */
public class IRIs {

    public static final String RDFS = "http://www.w3.org/2000/01/rdf-schema#";
    public static final String ONT = "http://www.semanticweb.org/lenovo/ontologies/2018/7/indian_biodiversity#";
    public static final String OWL = "http://www.w3.org/2002/07/owl#";
    public static final String RDF = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";

    public static final String QUERYHEADER = "PREFIX rdfs: <" + RDFS + "> " +
                                        "PREFIX ont: <" + ONT + "> "+
                                        "PREFIX rdf: <" + RDF + ">" +
                                        "PREFIX owl: <" + OWL + ">";

    public static final String[] PREFIXES = {"rdfs", "ont", "owl", "rdf"};

    public static String getShortNameFromIRI(String fullName) {
        String res = fullName;
        if(fullName.contains("#")) {
            res = fullName.substring(fullName.indexOf("#")+1);
        }
        return res;
    }
}
