#!/usr/bin/env bash +ex

OFFSET=14

gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/kappa.pdf"  -dFirstPage=$((3))  -dLastPage=$((76+OFFSET))  -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperA.pdf" -dFirstPage=$((79+OFFSET))  -dLastPage=$((127+OFFSET)) -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperB.pdf" -dFirstPage=$((129+OFFSET)) -dLastPage=$((143+OFFSET)) -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperC.pdf" -dFirstPage=$((145+OFFSET)) -dLastPage=$((159+OFFSET)) -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperD.pdf" -dFirstPage=$((161+OFFSET)) -dLastPage=$((176+OFFSET)) -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperE.pdf" -dFirstPage=$((177+OFFSET)) -dLastPage=$((192+OFFSET)) -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperF.pdf" -dFirstPage=$((193+OFFSET)) -dLastPage=$((208+OFFSET)) -sDEVICE=pdfwrite "MAIN.pdf"
gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="split/paperG.pdf" -dFirstPage=$((209+OFFSET)) -dLastPage=$((239+OFFSET)) -sDEVICE=pdfwrite "MAIN.pdf"

echo "kappa:"
gs -o - -sDEVICE=inkcov split/kappa.pdf | awk '
/^Page/ {
  page=$2
  getline
  split($0, a, " ")
  if (a[1]>0 || a[2]>0 || a[3]>0) pages = pages ? pages ", " page : page
}
END { if (pages) print pages }
'

echo "Paper A:"
gs -o - -sDEVICE=inkcov split/paperA.pdf | awk '
/^Page/ {
  page=$2
  getline
  split($0, a, " ")
  if (a[1]>0 || a[2]>0 || a[3]>0) pages = pages ? pages ", " page : page
}
END { if (pages) print pages }
'

echo "Paper B:"
gs -o - -sDEVICE=inkcov split/paperB.pdf | awk '
/^Page/ {
  page=$2
  getline
  split($0, a, " ")
  if (a[1]>0 || a[2]>0 || a[3]>0) pages = pages ? pages ", " page : page
}
END { if (pages) print pages }
'

echo "Paper C:"
gs -o - -sDEVICE=inkcov split/paperC.pdf | awk '
/^Page/ {
  page=$2
  getline
  split($0, a, " ")
  if (a[1]>0 || a[2]>0 || a[3]>0) pages = pages ? pages ", " page : page
}
END { if (pages) print pages }
'

echo "Paper D:"
gs -o - -sDEVICE=inkcov split/paperD.pdf | awk '
/^Page/ {
  page=$2
  getline
  split($0, a, " ")
  if (a[1]>0 || a[2]>0 || a[3]>0) pages = pages ? pages ", " page : page
}
END { if (pages) print pages }
'

echo "Paper E:"
gs -o - -sDEVICE=inkcov split/paperE.pdf | awk '
/^Page/ {
  page=$2
  getline
  split($0, a, " ")
  if (a[1]>0 || a[2]>0 || a[3]>0) pages = pages ? pages ", " page : page
}
END { if (pages) print pages }
'

echo "Paper F:"
gs -o - -sDEVICE=inkcov split/paperF.pdf | awk '
/^Page/ {
  page=$2
  getline
  split($0, a, " ")
  if (a[1]>0 || a[2]>0 || a[3]>0) pages = pages ? pages ", " page : page
}
END { if (pages) print pages }
'

echo "Paper G:"
gs -o - -sDEVICE=inkcov split/paperG.pdf | awk '
/^Page/ {
  page=$2
  getline
  split($0, a, " ")
  if (a[1]>0 || a[2]>0 || a[3]>0) pages = pages ? pages ", " page : page
}
END { if (pages) print pages }
'
