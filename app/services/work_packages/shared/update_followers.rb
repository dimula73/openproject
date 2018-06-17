#-- encoding: UTF-8

#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2018 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

module WorkPackages
  module Shared
    module UpdateFollowers
      def update_followers(changed_work_packages)
        changes = changed_work_packages
                  .map { |wp| wp.previous_changes.keys }
                  .flatten
                  .uniq
                  .map(&:to_sym)

        update_each_follower(changed_work_packages, changes)
      end

      def update_followers_all_attributes(work_packages)
        changes = work_packages
                  .first
                  .attributes
                  .keys
                  .uniq
                  .map(&:to_sym)

        update_each_follower(work_packages, changes)
      end

      def update_followers_after_delete(work_packages)
        changes = work_packages
                  .first
                  .attributes
                  .keys
                  .uniq
                  .map(&:to_sym)

        update_each_follower(work_packages, changes, true)
      end

      def update_each_follower(work_packages, changes, is_deleted = false)
        work_packages.map do |wp|
          update_one_follower(wp, changes, is_deleted)
        end
      end

      def update_one_follower(wp, changes, is_deleted)
        WorkPackages::UpdateFollowersService
          .new(user: user,
               work_package: wp,
               is_deleted: is_deleted)
          .call(changes)
      end
    end
  end
end