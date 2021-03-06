require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::Sample do
  it "has a version number" do
    expect(Metanorma::Sample::VERSION).not_to be nil
  end

  #it "generates output for the Rice document" do
  #  FileUtils.rm_f %w(spec/examples/rfc6350.doc spec/examples/rfc6350.html spec/examples/rfc6350.pdf)
  #  FileUtils.cd "spec/examples"
  #  Asciidoctor.convert_file "rfc6350.adoc", {:attributes=>{"backend"=>"sample"}, :safe=>0, :header_footer=>true, :requires=>["metanorma-sample"], :failure_level=>4, :mkdirs=>true, :to_file=>nil}
  #  FileUtils.cd "../.."
  #  expect(xmlpp(File.exist?("spec/examples/rfc6350.doc"))).to be true
  #  expect(xmlpp(File.exist?("spec/examples/rfc6350.html"))).to be true
  #  expect(xmlpp(File.exist?("spec/examples/rfc6350.pdf"))).to be true
  #end

  it "processes a blank document" do
    input = <<~"INPUT"
    #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</sample-standard>
    OUTPUT

    expect(xmlpp(Asciidoctor.convert(input, backend: :sample, header_footer: true))).to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</sample-standard>
    OUTPUT

    FileUtils.rm_f "test.html"
    expect(xmlpp(Asciidoctor.convert(input, backend: :sample, header_footer: true))).to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
  end

  it "processes default metadata" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee: TC
      :committee-number: 1
      :committee-type: A
      :committee_2: TC1
      :committee-number_2: 11
      :committee-type_2: A1
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: en
      :title: Main Title
      :security: Client Confidential
    INPUT

    output = xmlpp(<<~"OUTPUT")
    <?xml version="1.0" encoding="UTF-8"?>
<sample-standard xmlns="https://open.ribose.com/standards/example">
<bibdata type="standard">
<title language="en" format="text/plain">Main Title</title>
<docidentifier type="acme">1000(wd):2001</docidentifier>
<docnumber>1000</docnumber>
  <edition>2</edition>
<version>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version> 
  <contributor>
    <role type="author"/>
    <organization>
      <name>Acme</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>Acme</name>
    </organization>
  </contributor>
  <language>en</language>
  <script>Latn</script>
  <status>
    <stage>working-draft</stage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>Acme</name>
      </organization>
    </owner>
  </copyright>
  <ext>
  <doctype>standard</doctype>
  <editorialgroup>
    <committee type="A">TC</committee>
    <committee type="A1">TC1</committee>
  </editorialgroup>
  <security>Client Confidential</security>
  </ext>
</bibdata>
<sections/>
</sample-standard>
    OUTPUT

    expect(xmlpp(Asciidoctor.convert(input, backend: :sample, header_footer: true))).to be_equivalent_to output
  end

      it "processes committee-draft" do
    expect(xmlpp(Asciidoctor.convert(<<~"INPUT", backend: :sample, header_footer: true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :status: committee-draft
      :iteration: 3
      :language: en
      :title: Main Title
    INPUT
        <sample-standard xmlns="https://open.ribose.com/standards/example">
<bibdata type="standard">
  <title language="en" format="text/plain">Main Title</title>
  <docidentifier type="acme">1000(cd)</docidentifier>
  <docnumber>1000</docnumber>
  <edition>2</edition>
<version>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version> 
  <contributor>
    <role type="author"/>
    <organization>
      <name>Acme</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>Acme</name>
    </organization>
  </contributor>
  <language>en</language>
  <script>Latn</script>
  <status>
    <stage>committee-draft</stage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>#{Date.today.year}</from>
    <owner>
      <organization>
        <name>Acme</name>
      </organization>
    </owner>
  </copyright>
  <ext>
  <doctype>standard</doctype>
  </ext>
</bibdata>
<sections/>
</sample-standard>
        OUTPUT
    end

              it "processes draft-standard" do
    expect(xmlpp(Asciidoctor.convert(<<~"INPUT", backend: :sample, header_footer: true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :status: draft-standard
      :iteration: 3
      :language: en
      :title: Main Title
    INPUT
        <sample-standard xmlns="https://open.ribose.com/standards/example">
<bibdata type="standard">
  <title language="en" format="text/plain">Main Title</title>
  <docidentifier type="acme">1000(d)</docidentifier>
  <docnumber>1000</docnumber>
  <edition>2</edition>
<version>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>   <contributor>
    <role type="author"/>
    <organization>
      <name>Acme</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>Acme</name>
    </organization>
  </contributor>
  <language>en</language>
  <script>Latn</script>
  <status>
    <stage>draft-standard</stage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>#{Date.today.year}</from>
    <owner>
      <organization>
        <name>Acme</name>
      </organization>
    </owner>
  </copyright>
  <ext>
    <doctype>standard</doctype>
  </ext>
</bibdata>
<sections/>
</sample-standard>
OUTPUT
        end

                  it "ignores unrecognised status" do
        expect(xmlpp(Asciidoctor.convert(<<~"INPUT", backend: :sample, header_footer: true))).to be_equivalent_to <<~'OUTPUT'
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :copyright-year: 2001
      :status: standard
      :iteration: 3
      :language: en
      :title: Main Title
    INPUT
    <sample-standard xmlns="https://open.ribose.com/standards/example">
<bibdata type="standard">
  <title language="en" format="text/plain">Main Title</title>
  <docidentifier type="acme">1000:2001</docidentifier>
  <docnumber>1000</docnumber>
  <edition>2</edition>
<version>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version> 
 <contributor>
    <role type="author"/>
    <organization>
      <name>Acme</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>Acme</name>
    </organization>
  </contributor>
  <language>en</language>
  <script>Latn</script>
  <status>
    <stage>standard</stage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>Acme</name>
      </organization>
    </owner>
  </copyright>
  <ext>
    <doctype>standard</doctype>
  </ext>
</bibdata>
<sections/>
</sample-standard>
    OUTPUT
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
             <preface><foreword obligation="informative">
         <title>Foreword</title>
         <p id="_">This is a preamble</p>
       </foreword></preface><sections>
       <clause id="_" obligation="normative">
         <title>Section 1</title>
       </clause></sections>
       </sample-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :sample, header_footer: true)))).to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :sample, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "Overpass", sans-serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "Overpass", sans-serif;]m)
  end

  it "uses Chinese fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :sample, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "SimHei", sans-serif;]m)
  end

  it "uses specified fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :sample, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
  end

  it "processes inline_quoted formatting" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      _emphasis_
      *strong*
      `monospace`
      "double quote"
      'single quote'
      super^script^
      sub~script~
      stem:[a_90]
      stem:[<mml:math><mml:msub xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">F</mml:mi> </mml:mrow> </mml:mrow> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">&#x391;</mml:mi> </mml:mrow> </mml:mrow> </mml:msub> </mml:math>]
      [keyword]#keyword#
      [strike]#strike#
      [smallcap]#smallcap#
    INPUT

    output = xmlpp(<<~"OUTPUT")
            #{BLANK_HDR}
       <sections>
        <p id="_"><em>emphasis</em>
       <strong>strong</strong>
       <tt>monospace</tt>
       “double quote”
       ‘single quote’
       super<sup>script</sup>
       sub<sub>script</sub>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mi>a</mi><mn>90</mn></msub></math></stem>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub> <mrow> <mrow> <mi mathvariant="bold-italic">F</mi> </mrow> </mrow> <mrow> <mrow> <mi mathvariant="bold-italic">Α</mi> </mrow> </mrow> </msub> </math></stem>
       <keyword>keyword</keyword>
       <strike>strike</strike>
       <smallcap>smallcap</smallcap></p>
       </sections>
       </sample-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :sample, header_footer: true)))).to be_equivalent_to output
  end


end
