class ChangeAvatarsFormatMicroposts < ActiveRecord::Migration
  def change
      def self.up  
       change_column :microposts, :avatars, :string  
      end  
      
      def self.down  
       change_column :microposts, :avatars, :json
      end  
  end
end
