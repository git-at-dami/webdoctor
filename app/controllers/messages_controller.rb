# frozen_string_literal: true

class MessagesController < ApplicationController
  def show
    @message = Message.find(params[:id])
    Messages::MarkMessageAsRead.new(@message, params[:user_type]).call
  rescue ActiveRecord::RecordNotFound
    logger.error("Message not found with id: #{params[:id]}")
    flash[:alert] = "The message you're looking for could not be found."
    redirect_to messages_path
  end

  def index
    @messages = User.current(params[:user_type]).inbox.messages.page(params[:page])
  end

  def new
    @parent_message_id = params[:parent_message_id]
    @parent_message = Message.find(@parent_message_id) if @parent_message_id
    @message = Message.new
  end

  def create
    result = Messages::CreateMessage.new.call(**message_params, user_type: params[:user_type])

    if result.success?
      redirect_to message_path(result.value!, user_type: params[:user_type]), notice: 'message sent'
    else
      @message = result.failure
      @parent_message_id = message_params[:parent_message_id]

      flash[:error] = 'invalid message.'
      render :new, status: :unprocessable_entity
    end
  end

  def reissue_prescription
    result = Messages::ReissuePrescriptionNote.new.call(params[:id])

    if result.success?
      redirect_to messages_path(params[:user_type]),
                  notice: 'Your request has been sent. A new prescription will be issued shortly.'
    else
      flash[:error] = 'There was an error processing your request. Please try again later or contact support.'

      redirect_to root_path
    end
  end

  def message_params
    params.require(:message).permit(%i[body parent_message_id]).to_h.symbolize_keys
  end
end
