require File.dirname(__FILE__) + '/../spec_helper'

describe User, "validations" do
  dataset :users
  test_helper :validations
  
  before :each do
    @model = @user = User.new(user_params)
    @user.confirm_password = false
  end
  
  it 'should validate length of' do
    assert_invalid :name, 'this must not be longer than 100 characters', 'x' * 101
    assert_valid :name, 'x' * 100
    
    assert_invalid :email, 'this must not be longer than 255 characters', ('x' * 247) + '@test.com'
    assert_valid :email, ('x' * 246) + '@test.com'
  end
  
  
  describe "self.unprotected_attributes" do
    it "should be an array of [:name, :email, :login, :password, :password_confirmation, :locale]" do
      # Make sure we clean up after anything set in another spec
      User.instance_variable_set(:@unprotected_attributes, nil)
      User.unprotected_attributes.should == [:name, :email, :login, :password, :password_confirmation, :locale]
    end
  end
  describe "self.unprotected_attributes=" do
    it "should set the @@unprotected_attributes variable to the given array" do
      User.unprotected_attributes = [:password, :email, :other]
      User.unprotected_attributes.should == [:password, :email, :other]
    end
  end
  
  it 'should validate length ranges' do
    {
      :login => 3..40,
      :password => 5..40
    }.each do |field, range|
      max = 'x' * range.max
      min = 'x' * range.min
      one_over = 'x' + max
      one_under = min[1..-1]
      assert_invalid field, ('this must not be longer than %d characters' % range.max), one_over
      assert_invalid field, ('this must be at least %d characters long' % range.min), one_under
      assert_valid field, max, min
    end
  end
  
  it 'should validate length ranges on existing' do
    @user.save.should == true
    {
      :password => 5..40
    }.each do |field, range|
      max = 'x' * range.max
      min = 'x' * range.min
      one_over = 'x' + max
      one_under = min[1..-1]
      assert_invalid field, ('this must not be longer than %d characters' % range.max), one_over
      assert_invalid field, ('this must be at least %d characters long' % range.min), one_under
      assert_valid field, max, min
    end
  end
  
  it 'should validate presence' do
    [:name, :login, :password, :password_confirmation].each do |field|
      assert_invalid field, 'this must not be blank', '', ' ', nil
    end
  end
  
  it 'should validate numericality' do
    [:id].each do |field|
      assert_valid field, '1', '0'
      assert_invalid field, 'this must be a number', 'abcd', '1,2', '1.3'
    end
  end
  
  it 'should validate confirmation' do
    @user.confirm_password = true
    assert_invalid :password, 'this must match confirmation', 'test'
  end
  
  it 'should validate uniqueness' do
    assert_invalid :login, 'this login is already in use', 'existing'
  end
  
  it 'should validate format' do
    assert_invalid :email, 'this is not a valid e-mail address', '@test.com', 'test@', 'testtest.com',
      'test@test', 'test me@test.com', 'test@me.c'
    assert_valid :email, '', 'test@test.com'
  end
end

describe User do
  dataset :users
  
  before :each do
    @user = User.new(user_params)
    @user.confirm_password = false
  end
  
  it 'should confirm the password by default' do
    @user = User.new
    @user.confirm_password?.should == true
  end
  
  it 'should save password encrypted' do
    @user.confirm_password = true
    @user.password_confirmation = @user.password = 'test_password'
    @user.save!
    @user.password.should == @user.sha1('test_password')
  end
  
  it 'should save existing but empty password' do
    @user.save!
    @user.password_confirmation = @user.password = ''
    @user.save!
    @user.password.should == @user.sha1('password')
  end
  
  it 'should save existing but different password' do
    @user.save!
    @user.password_confirmation = @user.password = 'cool beans'
    @user.save!
    @user.password.should == @user.sha1('cool beans')
  end
  
  it 'should save existing but same password' do
    @user.save! && @user.save!
    @user.password.should == @user.sha1('password')
  end
  
  it "should create a salt when encrypting the password" do
    @user.salt.should be_nil
    @user.send(:encrypt_password)
    @user.salt.should_not be_nil
    @user.password.should == @user.sha1('password')
  end

  describe ".remember_me" do
    before do
      Radiant::Config.stub!(:[]).with('session_timeout').and_return(2.weeks)
      @user.save
      @user.remember_me
      @user.reload
    end

    it "should remember user" do
      @user.session_token.should_not be_nil
    end
  end

  describe ".forget_me" do

    before do
      Radiant::Config.stub!(:[]).with('session_timeout').and_return(2.weeks)
      @user.save
      @user.remember_me
    end

    it "should forget user" do
      @user.forget_me
      @user.session_token.should be_nil
    end
  end
  
end

describe User, "class methods" do
  dataset :users
  
  it 'should authenticate with correct username and password' do
    expected = users(:existing)
    user = User.authenticate('existing', 'password')
    user.should == expected
  end
  
  it 'should authenticate with correct email and password' do
    expected = users(:existing)
    user = User.authenticate('existing@example.com', 'password')
    user.should == expected
  end
  
  it 'should not authenticate with bad password' do
    User.authenticate('existing', 'bad password').should be_nil
  end
  
  it 'should not authenticate with bad user' do
    User.authenticate('nonexisting', 'password').should be_nil
  end
end

describe User, "roles" do
  dataset :users
  
  it "should not have a non-existent role" do
    users(:existing).has_role?(:foo).should be_false
  end
  
  it "should not have a role for which the corresponding method returns false" do
    users(:existing).has_role?(:designer).should be_false
    users(:existing).has_role?(:admin).should be_false
  end
  
  it "should have a role for which the corresponding method returns true" do
    users(:designer).has_role?(:designer).should be_true
    users(:admin).has_role?(:admin).should be_true
  end
end