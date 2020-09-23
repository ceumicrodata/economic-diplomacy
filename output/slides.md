% preamble.tex

== What is the difference in trade policy of EU Member States? ==
1. None.
2. Let's explore.

== Sample and data ==
=== Sample ===
- EU Member States as of 2017.
- EU candidate and potential members
- European Neighbourhood Policy 

=== Data ===
- External trade from COMEXT (HS6 level)
- World Development Indicators (World Bank)
- CEPII GeoDist
- Global Database of Events, Language and Tone (GDELT) 2.0
- Affinity of Nations (Voting patterns in UN General Assembly)
- Special Eurobarometer 491: Europeans' attitudes on Trade and EU trade policy

== Meausures of interest ==
{\small
\input{results_descriptives.tex}}

== A gravity equation for state visits ==
{\small\input{results_without_fe.tex}}

== In harmony with your neighbor ==
{\footnotesize\input{results_eu_neighbor.tex}}

== Not all EU countries are alike ==
{\footnotesize\input{results_po.tex}}

== An index of Trade Similarity ==
- For any pair of countries (EU--neighbour), compare their export product shares to the EU average.
- Convert this index of divergence to a [0,1] index of Trade Similarity.

