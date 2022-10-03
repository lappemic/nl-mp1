#!/bin/zsh

mkdir -p compiled images

# ############ Convert friendly and compile to openfst ############
for i in friendly/*.txt; do
	echo "Converting friendly: $i"
   python compact2fst.py  $i  > sources/$(basename $i ".formatoAmigo.txt").txt
done


# ############ convert words to openfst ############
for w in tests/*.str; do
	echo "Converting words: $w"
	./word2fst.py `cat $w` > tests/$(basename $w ".str").txt
done


# ############ Compile source transducers ############
for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

# ############ CORE OF THE PROJECT  ############








# ############ generate PDFs  ############
echo "Starting to generate PDFs"
for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
   fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done



# ############ tests  ############

echo "Testing ABCDE"

for w in compiled/t-*.fst; do
    fstcompose $w compiled/removeVowel.fst | fstshortestpath | fstproject --project_type=output |
    fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done


echo "####################### TESTING OF STEP 1 #######################"

echo "Testing step 1 with ERRORS (drop duplicated adjacent letters, except 'C')"
fstcompose compiled/t-errors.fst compiled/step1.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 1 with ACCORDING (drop duplicated adjacent letters, except 'C')"
fstcompose compiled/t-according.fst compiled/step1.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 1 with RUSSIAN (drop duplicated adjacent letters, except 'C')"
fstcompose compiled/t-russian.fst compiled/step1.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



echo "####################### TESTING OF STEP 2 #######################"

echo "Testing step 2 with KNEE (if word begins with 'KN', 'GN', 'PN', 'AE', or 'WR', drop first letter)"
fstcompose compiled/t-knee.fst compiled/step2.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 2 with GNOME (if word begins with 'KN', 'GN', 'PN', 'AE', or 'WR', drop first letter)"
fstcompose compiled/t-gnome.fst compiled/step2.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 2 with WRAPPERS (if word begins with 'KN', 'GN', 'PN', 'AE', or 'WR', drop first letter)"
fstcompose compiled/t-wrappers.fst compiled/step2.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 2 with BREADCRUMB (if the word ends with 'MB' drop the 'B'.)"
fstcompose compiled/t-breadcrumb.fst compiled/step2.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



echo "####################### TESTING OF STEP 3 #######################"

echo "Testing step 3 with SCHOOL (-> SKHOOL)"
fstcompose compiled/t-school.fst compiled/step3.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 3 with ACHIEVER (-> AXHIEVER)"
fstcompose compiled/t-achiever.fst compiled/step3.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 3 with PRONUNCIATION (-> PRONUNXIATION)"
fstcompose compiled/t-pronunciation.fst compiled/step3.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 3 with VICIOUS (-> VISIOUS)"
fstcompose compiled/t-vicious.fst compiled/step3.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 3 with ABSENCE (-> ABSENSE)"
fstcompose compiled/t-absence.fst compiled/step3.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 3 with CYBERNETICIAN (-> SYBERNETIXIAN)"
fstcompose compiled/t-cybernetician.fst compiled/step3.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 3 with CULTURE (-> KULTURE)"
fstcompose compiled/t-culture.fst compiled/step3.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



echo "####################### TESTING OF STEP 4 #######################"

echo "Testing step 4 with PLEDGES (-> PLEJGES)"
fstcompose compiled/t-pledges.fst compiled/step4.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 4 with FUDGY (-> FUJGY)"
fstcompose compiled/t-fudgy.fst compiled/step4.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 4 with BUDGIES (-> BUJGIES)"
fstcompose compiled/t-budgies.fst compiled/step4.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 4 with ABDUCED (-> ABTUCET)"
fstcompose compiled/t-abduced.fst compiled/step4.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 4 with AID (-> AIT)"
fstcompose compiled/t-aid.fst compiled/step4.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



echo "####################### TESTING OF STEP 5 #######################"

echo "Testing step 5 with FIGHT (-> FIHT)"
fstcompose compiled/t-fight.fst compiled/step5.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 5 with FOREIGN (-> FOREIN) -> TO DO: HAS TO BE CHECKED - G OR N TO DROP?"
fstcompose compiled/t-foreign.fst compiled/step5.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 5 with SIGNED (-> SINED)"
fstcompose compiled/t-signed.fst compiled/step5.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



echo "####################### TESTING OF STEP 6 #######################"

echo "Testing step 6 with FIHT (-> FIT)"
fstcompose compiled/t-fiht.fst compiled/step6.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 6 with MAHARAJAH (-> MAHARAJA)"
fstcompose compiled/t-maharajah.fst compiled/step6.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 6 with LUCK (-> LUK)"
fstcompose compiled/t-luck.fst compiled/step6.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 6 with PHOTO (-> FOTO)"
fstcompose compiled/t-photo.fst compiled/step6.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 6 with QUITE (-> KUITE)"
fstcompose compiled/t-quite.fst compiled/step6.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 6 with SHOULD (-> XHOULD)"
fstcompose compiled/t-should.fst compiled/step6.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 6 with COMISIONER (-> COMIXIONER)"
fstcompose compiled/t-comisioner.fst compiled/step6.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 6 with RUSIA (-> RUXIA)"
fstcompose compiled/t-rusia.fst compiled/step6.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



echo "####################### TESTING OF STEP 7 #######################"

echo "Testing step 7 with SUBSTANTIAL (-> SUBSTANXIAL)"
fstcompose compiled/t-substantial.fst compiled/step7.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 7 with CALCULATION (-> CALCULAXION)"
fstcompose compiled/t-calculation.fst compiled/step7.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 7 with THE (-> 0E)"
fstcompose compiled/t-the.fst compiled/step7.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 7 with MATCH (-> MACH)"
fstcompose compiled/t-match.fst compiled/step7.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 7 with HAVE (-> HAFE)"
fstcompose compiled/t-have.fst compiled/step7.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 7 with WHAT (-> WAT)"
fstcompose compiled/t-what.fst compiled/step7.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



echo "####################### TESTING OF STEP 8 #######################"

echo "Testing step 8 with XENON (-> SENON)"
fstcompose compiled/t-xenon.fst compiled/step8.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 8 with SEX (-> SEKS)"
fstcompose compiled/t-sex.fst compiled/step8.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 8 with LAWN (-> LAN)"
fstcompose compiled/t-lawn.fst compiled/step8.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 8 with BY (-> B)"
fstcompose compiled/t-by.fst compiled/step8.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 8 with KEYBOARD (-> KEBOARD)"
fstcompose compiled/t-keyboard.fst compiled/step8.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 8 with SIZE (-> SISE)"
fstcompose compiled/t-size.fst compiled/step8.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt



echo "####################### TESTING OF STEP 9 #######################"

echo "Testing step 9 with USE (-> US)"
fstcompose compiled/t-use.fst compiled/step9.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 8 with KEBOARD (-> KBRD)"
fstcompose compiled/t-keboard.fst compiled/step9.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
