require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #index" do
    

    before { get :index, params: { question_id: question.id } }

    it "populates an array of all answers of question" do
      answers = create_list(:answer, 3, question: question)   
      expect(response).to be_successful
      expect(assigns(:answers)).to eq(answers)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET :show" do
    let(:answer) { create(:answer, question: question) }

    it "render template :show for answer" do
      get :show, params: { id: answer }
      expect(response).to render_template :show 
    end
  end

  describe "GET #new" do
    it "returns a new answer form" do
      get :new, params: { question_id: question.id }
      expect(response).to be_successful
      expect(assigns(:answer)).to be_a_new(Answer)
      expect(assigns(:question)).to eq(question)
    end

    it "renders the :new template" do
      get :new, params: { question_id: question.id }
      expect(response).to render_template(:new)
    end
  end
  

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new answer" do
        post :create, params: { question_id: question.id, answer: { body: "Answer body" } }
        expect(Answer.last.body).to eq("Answer body")
      end
    

      it "redirect to question page" do
        post :create, params: { question_id: question.id, answer: { body: "Answer body" } }
        expect(response).to redirect_to(question_path(question))
      end
      
      
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect do
          post :create, params: { question_id: question.id, answer: { body: "" } }
        end.to_not change(Answer, :count)

      end
      it "re-renders new view" do
        post :create, params: { question_id: question.id, answer: { body: "" } }
        expect(response).to render_template(:new)
      end
    end
  end
end
