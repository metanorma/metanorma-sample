require_relative "base_convert"
require "isodoc"

module IsoDoc
  module Sample
    # A {Converter} implementation that generates Word output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def default_fonts(options)
        {
          bodyfont: (options[:script] == "Hans" ? '"SimSun",serif' : '"Arial",sans-serif'),
          headerfont: (options[:script] == "Hans" ? '"SimHei",sans-serif' : '"Arial",sans-serif'),
          monospacefont: '"Courier New",monospace'
        }
      end

      def default_file_locations(_options)
        {
          wordstylesheet: html_doc_path("wordstyle.scss"),
          standardstylesheet: html_doc_path("sample.scss"),
          header: html_doc_path("header.html"),
          wordcoverpage: html_doc_path("word_sample_titlepage.html"),
          wordintropage: html_doc_path("word_sample_intro.html"),
          ulstyle: "l3",
          olstyle: "l2",
        }
      end

      def make_body(xml, docxml)
        body_attr = { lang: "EN-US", link: "blue", vlink: "#954F72" }
        xml.body **body_attr do |body|
          make_body1(body, docxml)
          make_body2(body, docxml)
          make_body3(body, docxml)
        end
      end
      
      include BaseConvert
    end
  end
end
