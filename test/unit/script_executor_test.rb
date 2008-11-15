require File.dirname(__FILE__) + '/../test_helper'
require 'uri'

class ScriptExecutorTest < Test::Unit::TestCase
  context "A script executor" do
    setup do
      @script_executor = ScriptExecutor.new
    end

    should "at least exist" do
      assert_not_nil @script_executor
    end

    should "should fetch a url" do
      uri = 'http://www.google.com'
      fetched = @script_executor.fetch_uri(uri)
      assert_equal Hpricot(open(uri)).to_s, fetched.to_s
    end

    context "for titles" do
      should "inject a title when there is no head tag" do
        doc = Hpricot(%Q{<html><body><p>yo</p></body></html>})
        @script_executor.inject_title(doc, 'title')
        assert_equal %Q{<html><head><title>#{ScriptExecutor::TitlePrefix} - title</title></head><body><p>yo</p></body></html>}, doc.to_s
      end

      should "inject a title when there is a blank head tag" do
        doc = Hpricot(%Q{<html><head></head><body><p>yo</p></body></html>})
        @script_executor.inject_title(doc, 'title')
        assert_equal %Q{<html><head><title>#{ScriptExecutor::TitlePrefix} - title</title></head><body><p>yo</p></body></html>}, doc.to_s
      end

      should "inject the prefix when there is already a title" do
        doc = Hpricot(%Q{<html><head><title></title></head><body><p>yo</p></body></html>})
        @script_executor.inject_title(doc, 'title')
        assert_equal %Q{<html><head><title>#{ScriptExecutor::TitlePrefix} - title</title></head><body><p>yo</p></body></html>}, doc.to_s
      end

      should "inject the prefix when there is already a title" do
        doc = Hpricot(%Q{<html><head><title></title></head><body><p>yo</p></body></html>})
        @script_executor.inject_title(doc, 'title')
        assert_equal %Q{<html><head><title>#{ScriptExecutor::TitlePrefix} - title</title></head><body><p>yo</p></body></html>}, doc.to_s
      end
    end
  end
end