# ToMMoVcf2Annovar
Convert ToMMo 3.5KJPNv2 vcf files to Annovar genericdb format. Download site of vcf files is https://jmorp.megabank.tohoku.ac.jp/201806/downloads/

## ChangeLog
UPDATE (180710): fixed handling INFO column data of chrX and MT in tommo_separate_alternatives.rb

UPDATE (180702): To avoid duplicated entries, removed tommo-3.5kjpnv2-20180625-af_snvall-chrX_PAR2.vcf and use tommo-3.5kjpnv2-20180625-af_snvall-chrX_PAR3.vcf only. More details are in [PAR2 and PAR3 files](https://github.com/makohda/ToMMoVcf2Annovar#par2-and-par3-files)

## Usage
put ToMMo's vcf files to ./data/ directory, give apropriate permissions to scripts, then run convert script.

`./convert_35KJPNv2.sh`

It takes time about 13 min. using iMac (Retina 5K, 27-inch, 2017), 4.2 GHz Intel Core i7


It generates two files, tommo-3.5kjpnv2-20180625-af_snvall.MAF.genericdb and tommo-3.5kjpnv2-20180625-af_snvall.INFO.genericdb.

tommo-3.5kjpnv2-20180625-af_snvall.MAF.genericdb has minor allele information.

    1   110165  110165  A   G   0.0003
    1   110177  110177  A   T   0.0015

tommo-3.5kjpnv2-20180625-af_snvall.INFO.genericdb has allele count information. For chromosome X and mitochondrial genome (MT), MALE and FEMALE count data are separated.

    22   51244443   51244443   C   G   AC=7;AN=5428 # allele counts (AC) are merged
    X    60003      60003      A   G   AC_MALE=6;AN_MALE=2292; AC_FEMALE=10;AN_FEMALE=3820 # separated
    MT   16557      16557      A   G   AC_MALE=3;AN_MALE=1447; AC_FEMALE=11;AN_FEMALE=1005 # separated

## Details
### How scripts works
**convert_35KJPNv2.sh** mainly processes tommo-3.5kjpnv2-20180625-af_snvall-*.vcf files. It converts from vcf format to 6 colomn Annovar genericdb format

from vcf

    1   19878451   rs543585810      G   A        .   PASS                         AC=5;...
    1   19878618   rs1050550839     C   T,A      .   PASS                         AC=11,23;...
    1   26815020   .                G   C,A,T    .   VQSRTrancheSNP99.60to99.80   AC=800,1194;...

to 6 column

    1   19878451    19878451    G   A       AC=5;AN=9004
    1   19878618    19878618    C   T,A     AC=11,23;AN=7104
    1   26815020    26815020    G   C,A,T   AC=800,1194,1;AN=6990
    1   19878451    19878451    G   A       AF=0.0007
    1   19878618    19878618    C   T,A     AF=0.0011,0.0005
    1   26815020    26815020    G   C,A,T   AF=0.1111,0.1765,0.0111

**tommo_separate_alternatives.rb** separates multi allelic variants found in 6 column format. This ruby script automatically run in convert_35KJPNv2.sh

input data

    1   19878451    19878451    G   A       AC=5;AN=9004
    1   19878618    19878618    C   T,A     AC=11,23;AN=7104
    1   26815020    26815020    G   C,A,T   AC=800,1194,1;AN=6990
    1   19878451    19878451    G   A       AF=0.0007
    1   19878618    19878618    C   T,A     AF=0.0011,0.0005
    1   26815020    26815020    G   C,A,T   AF=0.1111,0.1765,0.0111

separated data

    1   19878451    19878451    G   A   AC=5;AN=9004
    1   19878618    19878618    C   T   AC=11;AN=7104
    1   19878618    19878618    C   A   AC=23;AN=7104
    1   26815020    26815020    G   C   AC=800;AN=6990
    1   26815020    26815020    G   A   AC=1194;AN=6990
    1   26815020    26815020    G   T   AC=1;AN=6990
    1   19878451    19878451    G   A   AF=0.0007
    1   19878618    19878618    C   T   AF=0.0011
    1   19878618    19878618    C   A   AF=0.0005
    1   26815020    26815020    G   C   AF=0.1111
    1   26815020    26815020    G   A   AF=0.1765
    1   26815020    26815020    G   T   AF=0.0111

### PAR2 and PAR3 files
From ID27839_pressrelease.pdf which contains the information about current 3.5KJPN release and distributed with other vcf files.

> This time SNVs of 2,005,093 SNVs (PAR 1 + PAR 2, cleared the criteria are 1,726,127 SNVs) are detected by standard analysis using GATK, and also analysis with XTR (X-chromosome-transposed region) region, 2,065,505 SNVs (1,750,054 SNVs cleared the criteria) were detected.

Roughly saying, PAR3.vcf contains PAR2.vcf data.

```
$ wc -l *PAR{2,3}.vcf
    2005207 tommo-3.5kjpnv2-20180625-af_snvall-chrX_PAR2.vcf
    2065619 tommo-3.5kjpnv2-20180625-af_snvall-chrX_PAR3.vcf
```

But, there are some differences (FILTER, AC, AN, etc), such as follows.

```
$ grep -wF 60009 data/*PAR{2,3}.vcf
data/tommo-3.5kjpnv2-20180625-af_snvall-chrX_PAR2.vcf:X 60009   rs565284081 A   G   .   VQSRTrancheSNP99.60to99.80  AC=6;AN=5990;AF=0.001;AC_MALE=2;AN_MALE=2616;...;AC_FEMALE=4;AN_FEMALE=3374;...
data/tommo-3.5kjpnv2-20180625-af_snvall-chrX_PAR3.vcf:X 60009   rs565284081 A   G   .   VQSRTrancheSNP99.80to99.90  AC=2;AN=6098;AF=0.0003;AC_MALE=1;AN_MALE=2672;...;AC_FEMALE=1;AN_FEMALE=3426;...
```

The problem is that there are several data which have same position and different allele frequencies.
From current release (2018/07/02), I only process PAR3.vcf, and don't include PAR2.vcf.

## Warning
In gene-hunting projects, a mistake in variant filtering may cause a disaster. Please recheck results from this script by yourself. The author gratefully welcome your bug reports.

## Contact
Masakazu KOHDA ma.kohda@gmail.com

## License
Copyright: Masakazu KOHDA
This software is released under the MIT License, see LICENSE.txt.
