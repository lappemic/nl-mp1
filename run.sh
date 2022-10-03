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

echo "Testing step 1 with ERRORS"

fstcompose compiled/t-errors.fst compiled/step1.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 1 with ACCORDING"

fstcompose compiled/t-according.fst compiled/step1.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


echo "Testing step 1 with RUSSIAN"

fstcompose compiled/t-russian.fst compiled/step1.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "####################### TESTING OF STEP 2 #######################"

echo "Testing step 2 with KNEE"

fstcompose compiled/t-knee.fst compiled/step2.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 2 with GNOME"

fstcompose compiled/t-gnome.fst compiled/step2.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing step 2 with WRAPPERS"

fstcompose compiled/t-wrappers.fst compiled/step2.fst| fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
