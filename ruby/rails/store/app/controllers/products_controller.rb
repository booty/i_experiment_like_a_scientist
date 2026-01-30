class ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy, :delete_image ]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @product.assign_attributes(product_params.except(:images))

    # Append new images instead of replacing existing ones
    if params[:product][:images].present?
      @product.images.attach(params[:product][:images])
    end

    if @product.save
      redirect_to products_path, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product was successfully deleted."
  end

  def delete_image
    image = @product.images.find(params[:image_id])
    image.purge
    redirect_to edit_product_path(@product), notice: "Image was successfully removed."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, images: [])
  end
end
