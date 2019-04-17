require "isodoc"
require_relative "metadata"
require "fileutils"

module IsoDoc
  module Sample
  	module BaseConvert
      def convert1(docxml, filename, dir)
        FileUtils.cp html_doc_path('logo.jpg'), File.join(@localdir, "logo.jpg")
        @files_to_delete << File.join(@localdir, "logo.jpg")
        super
      end

      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
      end
      
      def info(isoxml, out)
        @meta.security isoxml, out
        super
      end

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]} "
          t.br
          t.b do |b|
            name&.children&.each { |c2| parse(c2, b) }
          end
        end
      end

      def term_defs_boilerplate(div, source, term, preface)
        if source.empty? && term.nil?
          div << @no_terms_boilerplate
        else
          div << term_defs_boilerplate_cont(source, term)
        end
      end

      def i18n_init(lang, script)
        super
        @annex_lbl = "Appendix"
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def cleanup(docxml)
        super
        term_cleanup(docxml)
      end

      def term_cleanup(docxml)
        docxml.xpath("//p[@class = 'Terms']").each do |d|
          h2 = d.at("./preceding-sibling::*[@class = 'TermNum'][1]")
          h2.add_child("&nbsp;")
          h2.add_child(d.remove)
        end
        docxml
      end
  	end
  end
end
