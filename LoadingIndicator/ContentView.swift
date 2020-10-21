//
//  ContentView.swift
//  LoadingIndicator
//
//  Created by Arie Peretz on 20/10/2020.
//  Copyright © 2020 Arie Peretz. All rights reserved.
//

import SwiftUI
struct WalkingRectangleShape: Shape {
    var phaseX: CGFloat
    var phaseY: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(phaseX, phaseY) }
        set {
            self.phaseX = newValue.first
            self.phaseY = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let width = rect.width
            let height = rect.height
                        
            let padding: CGFloat = 8
            let cornerX = (width-4*padding)/4
            let cornerY = (height-4*padding)/4
            let lineX = width-2*(padding+cornerX)
            let lineY = height-2*(padding+cornerY)
            
            let center = CGPoint(x: padding+cornerX+phaseX*lineX, y: padding+cornerY+phaseY*lineY)
            let sizeX = min((center.x-padding)*2, (width-padding-center.x)*2)
            let sizeY = min((center.y-padding)*2, (height-padding-center.y)*2)
            
            let origin = CGPoint(x: center.x-sizeX/2, y: center.y-sizeY/2)
            let size = CGSize(width: sizeX, height: sizeY)
            
            path.move(to: CGPoint(x: origin.x + size.width/2, y: origin.y))
            path.addLine(to: CGPoint(x: origin.x + size.width, y: origin.y + size.height/2))
            path.addLine(to: CGPoint(x: origin.x + size.width/2, y: origin.y + size.height))
            path.addLine(to: CGPoint(x: origin.x, y: origin.y + size.height/2))
            path.addLine(to: CGPoint(x: origin.x + size.width/2, y: origin.y))
        }
    }
}

struct WalkingRectangle: View {
    var phase: Int
    
    func phaseInAxes()->(row:CGFloat,col:CGFloat) {
        if phase == 1 {
            return (1.0, 0.0)
        }
        else if phase == 2 {
            return (1.0, 1.0)
        }
        else if phase == 3 {
            return (0.0, 1.0)
        }
        else {
            return (0.0, 0.0)
        }
    }
    
    var body: some View {
        WalkingRectangleShape(phaseX: self.phaseInAxes().row, phaseY: self.phaseInAxes().col)
            .fill(Color.red)
    }
}


struct LoadingIndicator: View {
    @State var phases: [Int] = [0, 1, 2]
    @State var activeRect: Int = 2
    
    func animate() {
        withAnimation(.easeInOut(duration: 0.6)) {
            self.phases[activeRect] = (self.phases[activeRect] + 1)%4
        }
        self.activeRect = (self.activeRect + 2)%3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animate()
        }
    }
    
    var body: some View {
        ZStack {
            WalkingRectangle(phase: self.phases[0])
                .frame(width:100, height: 100)
            WalkingRectangle(phase: self.phases[1])
                .frame(width:100, height: 100)
            WalkingRectangle(phase: self.phases[2])
                .frame(width:100, height: 100)
        }
        .onAppear() {
            self.animate()
        }
    }
}
struct ContentView: View {
    var body: some View {
        LoadingIndicator()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
