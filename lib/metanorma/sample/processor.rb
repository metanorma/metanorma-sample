require "metanorma/processor"

module Metanorma
  module Sample
    class Processor < Metanorma::Processor

      def initialize
        @short = :sample
        @input_format = :asciidoc
        @asciidoctor_backend = :sample
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf"
        )
      end

      def version
        "Metanorma::Sample #{Metanorma::Sample::VERSION}"
      end

      def input_to_isodoc(file, filename)
        Metanorma::Input::Asciidoc.new.process(file, filename, @asciidoctor_backend)
      end

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::Sample::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :doc
          IsoDoc::Sample::WordConvert.new(options).convert(outname, isodoc_node)
        when :pdf
          IsoDoc::Sample::PdfConvert.new(options).convert(outname, isodoc_node)
        else
          super
        end
      end
    end
  end
end
