#!/bin/zsh

# AF
echo "create tommo-3.5kjpnv2-20180625-af_snvall.MAF.genericdb"
foreach vcf in data/tommo-3.5kjpnv2-20180625-af_snvall-{autosome,chrX_PAR2,chrX_PAR3,chrMT}.vcf
  perl -F"\t" -lane '$F[7] =~ s/.*?(AF=0.\d+|AF=0.\d+,0.\d+|AF=0.\d+,0.\d+,0.\d+|AF=1);.*/$1/; print join("\t", @F[0,1,1,3,4], $F[7])' ${vcf}
end | grep -v "^#" > tommo-3.5kjpnv2-20180625-af_snvall.MAF.genericdb.org
./tommo_separate_alternatives.rb tommo-3.5kjpnv2-20180625-af_snvall.MAF.genericdb.org | perl -pe 's/AF=//' > tommo-3.5kjpnv2-20180625-af_snvall.MAF.genericdb
echo "complete"

# other INFO
# chr1-22 AC=1;AN=6744;
# chrX,chrM AC_MALE=1;AN_MALE=2946;AC_FEMALE=0;AN_FEMALE=3798
echo "create tommo-3.5kjpnv2-20180625-af_snvall.INFO.genericdb"
perl -F"\t" -lane '$F[7] =~ s/(AC=.*?;AN=\d+);.*/$1/; print join("\t", @F[0,1,1,3,4], $F[7])' data/tommo-3.5kjpnv2-20180625-af_snvall-autosome.vcf | grep -v "^#" > tommo-3.5kjpnv2-20180625-af_snvall.INFO.genericdb.org

foreach vcf in data/{tommo-3.5kjpnv2-20180625-af_snvall-chrX_PAR2.vcf,tommo-3.5kjpnv2-20180625-af_snvall-chrX_PAR3.vcf,tommo-3.5kjpnv2-20180625-af_snvall-chrMT.vcf}
  perl -F"\t" -lane '$F[7] =~ s/AC=.*?;AN=\d+;AF=.*?;(.*)/$1/; $F[7] =~ s/(AF_MALE|AF_FEMALE)=.*?;//g; $F[7] =~ s/;ANN=.*//; $F[7] =~ s/AC_FEMALE/ AC_FEMALE/; print join("\t", @F[0,1,1,3,4], $F[7])' ${vcf}
end | grep -v "^#" >> tommo-3.5kjpnv2-20180625-af_snvall.INFO.genericdb.org

./tommo_separate_alternatives.rb tommo-3.5kjpnv2-20180625-af_snvall.INFO.genericdb.org > tommo-3.5kjpnv2-20180625-af_snvall.INFO.genericdb
echo "complete"

echo "check line numbers in two files"
wc -l tommo-3.5kjpnv2-20180625-af_snvall.MAF.genericdb
wc -l tommo-3.5kjpnv2-20180625-af_snvall.INFO.genericdb
