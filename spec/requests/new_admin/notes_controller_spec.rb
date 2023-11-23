require 'rails_helper'

RSpec.describe NewAdmin::NotesController, type: :request do
  describe 'GET #index' do
    context 'when user is signed in' do
      context 'when user is admin' do
        let(:user) { create(:user, :admin) }
        before { sign_in user }

        context 'when no filters are applied' do
          let!(:notes) { create_list(:note, 2) }

          it 'returns status code 200 ok' do
            get new_admin_notes_path

            expect(response).to have_http_status(:ok)
          end

          it 'renders the index template' do
            get new_admin_notes_path

            expect(response).to render_template(:index)
          end

          it 'shows the notes' do
            get new_admin_notes_path

            expect(response.body).to include(notes[0].title)
              .and include(notes[1].title)
          end
        end

        context 'when title filter is applied' do
          let!(:foo_note) { create(:note, title: 'Foo') }
          let!(:bar_note) { create(:note, title: 'Bar') }

          it 'returns only the filtered notes', :aggregate_failures do
            get new_admin_notes_path, params: { title: 'foo' }

            expect(response.body).to include('Foo')
            expect(response.body).not_to include('Bar')
          end
        end

        context 'when pagination is applied' do
          let!(:notes_list) { create_list(:note, 3) }

          it 'paginates the results', :aggregate_failures do
            get new_admin_notes_path, params: { per: 2 }

            expect(assigns(:notes).count).to eq(2)
          end
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        get new_admin_notes_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_notes_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #show' do
    let(:note) { create(:note) }

    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      it 'renders the show template' do
        get new_admin_show_note_url(note.id)

        expect(response).to render_template(:show)
      end

      it 'renders the correct note' do
        get new_admin_show_note_url(note.id)

        expect(response.body).to include(note.title)
          .and include(note.comment)
          .and include(note.rate)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:note) { create(:note) }
      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_show_note_url(note.id)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      let(:note) { create(:note) }

      it 'redirects to sign in page' do
        get new_admin_show_note_url(note.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
