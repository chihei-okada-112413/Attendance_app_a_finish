module AttendancesHelper

    TIME_00 = "00"
    TIME_15 = 15
    TIME_30 = 30
    TIME_45 = 45
  
    def attendance_state(attendance)
        # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
        if Date.current == attendance.worked_on
            return '出勤' if attendance.started_at.nil?
            return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
        end
        # どれにも当てはまらなかった場合はfalseを返します。
        false
    end
    def time_fix(t)
        if t <= 59 && t >= 45
          TIME_45
        elsif t < 45 && t >= 30
          TIME_30
        elsif t < 30 && t >= 15
          TIME_15
        elsif t < 15 && t >= 0
          TIME_00
        end
    end  
    
    # 出勤時間と退勤時間を受け取り、在社時間を計算して返す。
    def working_time(start, finish)
        format("%.2f", (((finish - start) / 60) / 60.0))
    end
end
