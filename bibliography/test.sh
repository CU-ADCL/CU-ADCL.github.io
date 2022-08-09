biber --tool our-pubs.bib | grep --color 'Duplicate\|ERROR\|$'
biber --tool unsubmitted.bib | grep --color 'Duplicate\|ERROR\|$'
# biber --tool --validate-datamodel references.bib | grep --color 'Duplicate\|ERROR\|$'
