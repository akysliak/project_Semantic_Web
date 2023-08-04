<%-- 
    Document   : searchInTaxTree
    Created on : 04.02.2019, 13:40:09
    Author     : Anastasiia Kysliak
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import= "java.util.LinkedList" %>
<%@page import= "mswQuery.*" %>
<%@page import= "gui.*" %>
<%@page import="mswQuery.MSWQuery"%>

<c:set var="language" value="${not empty param.language ? param.language : not empty language ? language : 'en'}" scope="session" />
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="<%= LSDR_Srcs.GUI_DATA %>" />
<fmt:setBundle basename="<%= LSDR_Srcs.ONTOLOGY_LABELS %>" var = "labels" scope = "session"/>

<c:if test="${empty taxTree}">
    <c:set var ="taxTree" value= '<%= new TaxonomicTree() %>' scope = "session" />
</c:if>

<% TaxonomicTree tTree = (TaxonomicTree)pageContext.findAttribute("taxTree"); %>
<%
    boolean reset = (request.getParameter("reset") != null);
    boolean search = (request.getParameter("search") != null);
    boolean lang = (request.getParameter("language") != null);

    if(reset) {
        tTree.reset();
    }
    else if(search) {
        TaxTreeLevel smallestSelectedElement = tTree.getSmallestSelectedElement();
        if(smallestSelectedElement == null) {%>
        <c:out value = "inside" />
            <c:set var = "search_no_selection" value = "${true}" />
        <%}
        else { %>
            <c:set var ="res_taxTree_names" value= '<%= MSWQuery.searchInTaxTree(smallestSelectedElement.getSelectedElement()) %>' scope = "session" />
            <c:set var ="res_taxTree_infFound" value= '<%= new DetailedResultsList() %>' scope = "session" />
            <c:redirect url="taxonomicTreeSearchResult.jsp"/>
        <%}
    }
    else if(!lang) {
        String[] levelsNames = tTree.getLevelsNamesAsString();
        for(int i = 0; i < levelsNames.length; ++i) {
            String name = levelsNames[i] + "_selected";
            String el_selected = request.getParameter(name);
            if(el_selected!=null) {
                if(el_selected.equals("none")) {
                    tTree.unselectElement(i);
                    break;
                }
                else {
                    tTree.setSelectedElement(TaxTreeLevelsNames.valueOf(levelsNames[i].toUpperCase()), el_selected);
                    break;
                }
            }
        }
    }
    LinkedList<String> res_taxTree_names = (LinkedList<String>)pageContext.findAttribute("res_taxTree_names");
%>

<c:set var="levels" value = '<%= tTree.getLevelsNamesAsString() %>'  scope = "session" />
<c:set var="levels_population" value = '<%= tTree.getLevels() %>'  scope = "session" />
<% TaxTreeLevel[] lev_population = ((TaxTreeLevel[])pageContext.findAttribute("levels_population")); %>

<c:set var ="level_selected" value ='${not empty level_selected? level_selected : "br"}' scope="session" />
<c:set var = "element_selected_name" value = "param.${level_selected}_selected" />
<c:set var ="element_selected" value ='${not empty level_selected? sessionScope[element_selected_name] : ""}' scope="session" />

<% String lev_selected = (String)pageContext.findAttribute("level_selected"); %>
<c:set var ="kingdom_list" value = '<%= lev_population[0].getElementList() %>' scope="session" />
<c:set var ="kingdom_selected" value ='<%= lev_population[0].getSelectedElement() %>' scope="session" />

<c:set var ="phylum_list" value = '<%= lev_population[1].getElementList() %>' scope="session" />
<c:set var ="phylum_selected" value ='<%= lev_population[1].getSelectedElement() %>' scope="session" />

<c:set var ="class_list" value = '<%= lev_population[2].getElementList() %>' scope="session" />
<c:set var ="class_selected" value ='<%= lev_population[2].getSelectedElement() %>' scope="session" />

<c:set var ="order_list" value = '<%= lev_population[3].getElementList() %>' scope="session" />
<c:set var ="order_selected" value ='<%= lev_population[3].getSelectedElement() %>' scope="session" />

<c:set var ="superfamily_list" value = '<%= lev_population[4].getElementList() %>' scope="session" />
<c:set var ="superfamily_selected" value ='<%= lev_population[4].getSelectedElement() %>' scope="session" />

<c:set var ="family_list" value = '<%= lev_population[5].getElementList() %>' scope="session" />
<c:set var ="family_selected" value ='<%= lev_population[5].getSelectedElement() %>' scope="session" />

<c:set var ="genus_list" value = '<%= lev_population[6].getElementList() %>' scope="session" />
<c:set var ="genus_selected" value ='<%= lev_population[6].getSelectedElement() %>' scope="session" />

<!DOCTYPE html>

<html lang="${language}">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <fmt:message key="IndianBioDiversityPortal" var="IndianBioDiversityPortal" />
        <title>${IndianBioDiversityPortal}</title>
    </head>
    <body>
        <link href="styleshit.css" rel="stylesheet" type="text/css">
        <fmt:message key="SearchInTaxTree" var="SearchInTaxTree" />
        <h1>${SearchInTaxTree}</h1>
        <form name="startForm" action="searchInTaxTree" method="post">
            <fmt:message key="Home" var="Home" />
            <fmt:message key="ByScientificName" var="ByScientificName" />
            <fmt:message key="ByProperties" var="ByProperties" />
            <input type="submit" value=${Home} onclick="form.action='index.jsp';">
            <input type="submit" value=${ByScientificName} onclick="form.action='searchByScientificName.jsp';">
            <input type="submit" value=${ByProperties} onclick="form.action='searchByProperties.jsp';">
        </form>
        <form>
            <c:if test = "${search_no_selection}">
                <label style="width: 10em; color: #F00"><fmt:message key= "No_level_selected" /></label>
            </c:if>
        </form>
        <c:forEach items="${levels}" var = "level" >
            <form>
                <table>
                    <tbody>
                        <tr>
                            <td style="width: 10em;"><fmt:message key= "${level}" /></td>
                            <td>
                                <select id="${level}_selected" name="${level}_selected" style="width: 20em;" onchange='submit()'>
                                    <c:set var = "element_list" value = "${level}_list" />
                                    <c:set var = "selected_element_name" value = "${level}_selected" />
                                    <option value="none" ${empty sessionScope[selected_element_name] ? 'selected' : ''}>-- <fmt:message key="select"/> --</option>
                                    <c:forEach items="${sessionScope[element_list]}" var = "el" >
                                        <option value="${el}" ${el == sessionScope[selected_element_name] ? 'selected' : ''}><fmt:message key="${el}" bundle = "${labels}" /></option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </c:forEach>
        <form>
            <input name ="reset" value ="<fmt:message key= "reset" />" type = "submit">
        </form>
        <form>
            <input name ="search" type ="submit" value = "<fmt:message key= "Search" />" >
        </form>
        <form>
            <select id="language" name="language" onchange="submit()">
                <option value="en" ${language == 'en' ? 'selected' : ''}>English</option>
                <option value="de" ${language == 'de' ? 'selected' : ''}>Deutsch</option>
                <option value="ru" ${language == 'ru' ? 'selected' : ''}>Русский</option>
            </select>
        </form>
    </body>
</html>
