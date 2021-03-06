all: report.html report2.pdf

clean:
	rm -f words.txt histogram.tsv histogram.png report.md report.html barplot_dat.tsv barplot.png report2.pdf

report_type2: report2.pdf

clean_type2: 
	rm -f vowels_count.tsv barplot_dat.tsv barplot.png report2.pdf

report_type1: report.html

clean_type1:
	rm -f histogram.png report.md report.html

report2.pdf: report2.Rmd barplot.png vowels_count.tsv barplot.png histogram.tsv
	Rscript -e 'Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc"); rmarkdown::render("$<")'

report.html: report.rmd histogram.png
	Rscript -e 'Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc"); rmarkdown::render("$<")'

barplot.png: barplot.R words.txt
	Rscript $<

histogram.png: histogram.tsv
	Rscript -e 'ggplot2::qplot(Length, Freq, data=read.delim("$<")); ggplot2::ggsave("$@")'
	rm Rplots.pdf

vowels_count.tsv: vowels.py words.txt
	python vowels.py

histogram.tsv: histogram.r words.txt
	Rscript $<

words.txt:
	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'
