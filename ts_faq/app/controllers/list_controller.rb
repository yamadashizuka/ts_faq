# -*- coding: utf-8 -*-

class ListController < ApplicationController

  # 一覧表示
  def index
    @list = Item.all
  end
  
  # キーワード検索
  def search
  
    # キーワードをセッションに保存
    if(params[:keyWords] == nil) then
      if(session[:keyWords] == nil) then session[:keyWords] = "" end
    else
      session[:keyWords] = params[:keyWords]
    end
    
    # and/or条件をセッションに保存
    if(params[:condition] == nil) then
      if(session[:condition] == nil) then session[:condition] = "and" end
    else
      session[:condition] = params[:condition]
    end
    
    # 検索結果のリスト
    @list = Array.new
    
    # キーワードごとに検索
    keyWords = session[:keyWords].gsub(/　/," ").split
    if(keyWords.size == 0) then keyWords.push "" end
    
    idx = 0
    keyWords.each do |keyWord|
      # 項目の検索
      wk_list = Item.find(:all, :conditions => ["name LIKE ?", "%" + keyWord + "%"])
      
      # ケースの検索
      cases = Case.find(:all, :conditions => ["name LIKE ?", "%" + keyWord + "%"])
      cases.each do |a_case|
        if !(wk_list.include?(a_case.item)) then wk_list.push a_case.item end
      end

      # 手順の検索
      procedures = Procedure.find(:all, :conditions => ["name LIKE ?", "%" + keyWord + "%"])
      procedures.each do |procedure|
        if !(wk_list.include?(procedure.case.item)) then wk_list.push procedure.case.item end
      end

      # 検索結果のマージ
      if(idx == 0) then
        @list = @list + wk_list
      else
        if(session[:condition] == "and") then
          @list = @list & wk_list
        else
          @list = @list | wk_list
        end
      end
      
      idx = idx + 1
    end

    # ソート
    @list.sort!{|a, b| a.id <=> b.id}

    render :action => 'index'
  end
  
  # 追加
  def add
    @item = Item.new()
    @item.cases.build
    @item.cases[0].procedures.build
    render :action => 'edit'
  end

  # 編集
  def edit
    @item = Item.find(params[:id])
    render :action => 'edit'
  end

  
  # 削除
  def delete
    @item = Item.find(params[:id])
    if !(@item.nil?) then
      @item.destroy
    end
    search
  end
  
  # 保存（delete-insert方式で追加・更新を一括反映）
  def save
    # 同一トランザクション内で処理
    ActiveRecord::Base.transaction do
    
      # 既存データがあれば削除
      if (params[:itemid] != "") then
        @item = Item.find(params[:itemid])
        @item.destroy
      end
      
      # 項目を登録
      @item = Item.new(:id => params[:itemid], :name => params[:item], :update_user => params[:update_user])
      @item.save!
      
      # ケースと手順を登録
      caseids = params[:caseid]
      casenames = params[:casename]
      procedurenames = params[:procedurename]
      references = params[:reference]

      idx = 0
      caseids.each do |caseid|
        a_case = @item.cases.build
        a_case.name = casenames[idx]
        a_case.save!

        procedure = a_case.procedures.build
        procedure.name = procedurenames[idx]
        procedure.reference = references[idx]
        procedure.save!
        
        idx = idx + 1
      end
    end
    
    render :action => 'edit'
  end
end
