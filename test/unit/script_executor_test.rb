require File.dirname(__FILE__) + '/../test_helper'
require 'uri'

#todo: where to place this?
def search_helper *args
  matches = []
  @script_executor.search(*args) { |match|
    matches << match
  }
  matches
end

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
    end

    context "for searching" do
      setup do
        @doc = Hpricot(%Q{<html><head><title></title></head><body><div><p>yo</p></div><p class="win">bro</p></body></html>})
      end

      should "match ps" do
        assert_equal [(@doc/'p')], search_helper(@doc, 'p')
      end

      should "interpret slashes" do
        assert_equal [(@doc/'div'/'p')], search_helper(@doc, 'div/p')
      end

      should "permit sub selections" do
        test = proc { |i| assert_equal [(@doc/'p')[i].search('*')], search_helper(@doc, {'search' => 'p', 'at_indices' => i}) }
        test.call(0)
        test.call(1)
        test.call(-1)
      end

      should "match multiple targets" do
        assert_equal [(@doc/'p'), (@doc/'div')], search_helper(@doc, ['p', 'div'])
      end
    end
  end
end
