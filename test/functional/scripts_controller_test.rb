require 'test_helper'

class ScriptsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:scripts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_script
    assert_difference('Script.count') do
      post :create, :script => { }
    end

    assert_redirected_to script_path(assigns(:script))
  end

  def test_should_show_script
    get :show, :id => scripts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => scripts(:one).id
    assert_response :success
  end

  def test_should_update_script
    put :update, :id => scripts(:one).id, :script => { }
    assert_redirected_to script_path(assigns(:script))
  end

  def test_should_destroy_script
    assert_difference('Script.count', -1) do
      delete :destroy, :id => scripts(:one).id
    end

    assert_redirected_to scripts_path
  end
end
